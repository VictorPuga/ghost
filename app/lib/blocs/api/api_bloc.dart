import 'dart:async';
import 'dart:convert';

import 'package:bungie_api/enums/destiny_component_type_enum.dart';
import 'package:bungie_api/models/destiny_character_component.dart';
import 'package:bungie_api/models/destiny_character_response.dart';
import 'package:bungie_api/models/destiny_inventory_item_definition.dart';
import 'package:bungie_api/models/destiny_item_component.dart';
import 'package:bungie_api/models/destiny_item_instance_component.dart';
import 'package:bungie_api/models/destiny_profile_response.dart';
import 'package:bungie_api/models/user_membership_data.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/utils.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/models/models.dart';
import './api.dart';

class APIBloc extends Bloc<APIEvent, APIState> {
  final APIRepository apiRepository;
  final DBRepository dbRepository;

  APIBloc({
    @required this.apiRepository,
    this.dbRepository,
  }) : assert(apiRepository != null);

  @override
  APIState get initialState => InitialAPIState();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('Error on APIBloc:');
    print(error);
    if (error is DioError) {
      print(error.message);
      print(error.response);
    }
    print(stacktrace);
    this.dispatch(ThrowAPIError(error.toString(), stacktrace));
  }

  @override
  Stream<APIState> mapEventToState(
    APIEvent event,
  ) async* {
    if (event is ReceiveCredentials) {
      yield* _receiveCredentials(event);
    }

    if (event is GetUser) {
      throw Exception('`GetUser` event is not handled...');
      // yield APILoading();
      // await apiRepository.getUser(event.membershipId);
    }

    if (event is GetMembership) {
      throw Exception('`GetMembership` event is not handled...');
      // yield APILoading();
      // final UserMembershipData membership =
      //     await apiRepository.getMembership(event.accessToken);
    }

    if (event is RefreshToken) {
      yield* _refreshToken(event.token);
    }

    if (event is GetProfile) {
      yield* _getProfile(event);
    }

    if (event is GetCharacters) {
      yield* _getCharacters(event);
    }

    if (event is GetCharacter) {
      yield* _getCharacter(event);
    }

    if (event is EquipItem) {
      yield* _equipItem(event);
    }

    if (event is GetSets) {
      yield* _getSets(event);
    }

    if (event is GetAllItems) {
      yield* _getAllItems(event);
    }

    if (event is ThrowAPIError) {
      yield APIError(error: event.error, stacktrace: event.stackTrace);
    }
  }

  Stream<APIState> _receiveCredentials(ReceiveCredentials event) async* {
    yield APILoading();
    final Credentials credentials =
        apiRepository.parseCredentials(event.responseJson);

    final UserMembershipData membershipData =
        // A new instance is needed because it needs the access token
        await APIRepository(credentials.accessToken).getMembership();

    yield APICredentials(credentials, membershipData);
  }

  Stream<APIState> _getProfile(GetProfile event) async* {
    yield APILoading();
    final DestinyProfileResponse profile = await apiRepository.getProfile(
      card: event.card,
      components: event.components,
    );
    yield APIProfile(profile);
  }

  Stream<APIState> _getCharacters(GetCharacters event) async* {
    assert(dbRepository != null);
    if (currentState is APICharacters) {
      yield APILoading<APICharacters>(prevState: currentState);
    } else {
      yield APILoading();
    }
    final DestinyProfileResponse profileResponse =
        await apiRepository.getProfile(
      card: event.card,
      components: [DestinyComponentType.Characters],
    );

    final List<DestinyCharacterComponent> characterList =
        profileResponse.characters.data.values.toList();
    final List<CharacterData> characterData =
        await dbRepository.getCharacterData(characterList);

    final List<Character> characters = [
      Character.fromResponse(characterList[0], characterData[0]),
      Character.fromResponse(characterList[1], characterData[1]),
      Character.fromResponse(characterList[2], characterData[2]),
    ];
    yield APICharacters(characters);
  }

  Stream<APIState> _getCharacter(GetCharacter event) async* {
    assert(dbRepository != null);
    if (currentState is APICharacter) {
      yield APILoading<APICharacter>(prevState: currentState);
    } else {
      yield APILoading();
    }
    final DestinyCharacterResponse characterResponse =
        await apiRepository.getCharacter(
      card: event.card,
      characterId: event.characterId,
      components: [
        DestinyComponentType.CharacterInventories,
        DestinyComponentType.CharacterEquipment,
        DestinyComponentType.ItemInstances,
      ],
    );

    final sorted = await _computeSorted(
      characterResponse.inventory.data?.items ?? [],
      characterResponse.equipment.data?.items ?? [],
      characterResponse.itemComponents.instances.data ?? {},
      sortBy: event.sortBy,
    );

    SortedItems sortedItems;

    switch (event.sortBy) {
      case Sorting.bucket:
        final Map<int, Bucket> buckets =
            await dbRepository.getBucketData(sorted.keys.toList());
        sortedItems = SortedItems<Bucket>(
          categories: buckets,
          items: sorted,
        );
        break;
      case Sorting.type:
        throw Exception('Warning: case `Sorting.type` is not handled');
    }

    yield APICharacter(
      // items: items,
      sortedItems: sortedItems,
      // inventory: characterResponse.inventory,
      // equipment: characterResponse.equipment,
    );
  }

  Stream<APIState> _equipItem(EquipItem event) async* {
    APICharacter prevState;
    SortedItems sorted;
    if (currentState is APICharacter) {
      prevState = currentState;
      sorted = prevState.sortedItems;
      yield APILoading<APICharacter>(prevState: prevState);
    } else {
      yield APILoading();
    }

    final int code = await apiRepository.equipItem(
      id: event.id,
      characterId: event.characterId,
      membershipType: event.membershipType,
    );

    if (code == 1) {
      final newItems = sorted.items.map((k, v) {
        final Item equipping = v.singleWhere(
          (i) => i.itemInstanceId == event.id,
          orElse: () => null,
        );
        final Item equipped = v.singleWhere(
          (i) => i.isEquiped == true,
          orElse: () => null,
        );

        if (equipping != null && equipped != null) {
          final index = v.indexOf(equipping);
          v.remove(equipping);
          v.remove(equipped);
          equipping.equip();
          equipped.unEquip();
          v.insert(0, equipping);
          v.insert(index, equipped);
        }
        return MapEntry(k, v);
      });

      yield APICharacter(
        // items: prevState.items,
        sortedItems: SortedItems(
          categories: sorted.categories,
          items: newItems,
        ),
      );
    } else {
      // TODO: Implement APITransferError.
      print('Error equipping item. Code: $code');
      yield APICharacter(
        sortedItems: prevState.sortedItems,
        // TODO: Map error code to description
        error: jsonEncode({'code': code}),
      );
    }
  }

  Stream<APIState> _getSets(GetSets event) async* {
    assert(dbRepository != null);
    if (currentState is APISets) {
      yield APILoading<APISets>(prevState: currentState);
    } else {
      yield APILoading();
    }
    final DestinyProfileResponse profileResponse =
        await apiRepository.getProfile(
      card: event.card,
      components: [DestinyComponentType.Characters],
    );

    final List<String> characterIds =
        profileResponse.characters.data.keys.toList();

    final List<ItemSet> sets =
        await apiRepository.getSets(event.card.membershipId);

    yield APISets(
      characterIds: characterIds,
      sets: sets,
    );
  }

  Stream<APIState> _getAllItems(GetAllItems event) async* {
    assert(dbRepository != null);

    if (currentState is APIAllItems) {
      yield APILoading<APIAllItems>(prevState: currentState);
    } else {
      yield APILoading();
    }
    final DestinyProfileResponse profileResponse =
        await apiRepository.getProfile(
      card: event.card,
      components: [
        DestinyComponentType.ProfileInventories,
        DestinyComponentType.ItemInstances,
        DestinyComponentType.Characters,
        DestinyComponentType.CharacterInventories,
        DestinyComponentType.CharacterEquipment,
      ],
    );

    var sortedItems = SortedItems<Character>(
      categories: <int, Character>{},
      items: <int, List<Item>>{},
    );
    List<Item> vaultItems = [];

    for (int i = 0; i < 3; i++) {
      sortedItems.addTo(
        i,
        [],
        newCategory: Character(),
      );
    }

    if (event.characterId == null) {
      for (String id in profileResponse.characters.data.keys) {
        final list = await _computeItemList(
          profileResponse.characterInventories.data[id].items,
          profileResponse.characterEquipment.data[id].items,
          profileResponse.itemComponents.instances.data,
          orderBy: event.orderBy,
          bucketHash: event.bucketHash,
          statHash: event.statHash,
        );

        final DestinyCharacterComponent charComponent =
            profileResponse.characters.data[id];
        final List<CharacterData> data =
            await dbRepository.getCharacterData([charComponent]);

        final character = Character.fromResponse(charComponent, data[0]);

        sortedItems.addTo(
          num.tryParse(id),
          list,
          newCategory: character,
        );
      }
    } else {
      final sorted = await _computeItemList(
        profileResponse.characterInventories.data[event.characterId].items,
        profileResponse.characterEquipment.data[event.characterId].items,
        profileResponse.itemComponents.instances.data,
        orderBy: event.orderBy,
        bucketHash: event.bucketHash,
        statHash: event.statHash,
      );

      final DestinyCharacterComponent charComponent =
          profileResponse.characters.data[event.characterId];
      final List<CharacterData> data =
          await dbRepository.getCharacterData([charComponent]);

      final character = Character.fromResponse(charComponent, data[0]);

      sortedItems.addTo(
        num.tryParse(event.characterId),
        sorted,
        newCategory: character,
      );
    }
    vaultItems = await _computeItemList(
      profileResponse.profileInventory.data.items,
      [],
      profileResponse.itemComponents.instances.data,
      bucketHash: event.bucketHash,
      statHash: event.statHash,
      classHash: event.classCategoryHash,
    );

    yield APIAllItems(
      sortedItems: sortedItems,
      vaultItems: vaultItems,
    );
  }

  Stream<APIState> _refreshToken(String token) async* {
    await apiRepository.refreshToken(token);
  }

  Future<Map<int, List<Item>>> _computeSorted(
    List<DestinyItemComponent> inv,
    List<DestinyItemComponent> eq,
    Map<String, DestinyItemInstanceComponent> ins, {
    @required Sorting sortBy,
    Order orderBy,
  }) async {
    final inventory = [...inv]..removeWhere((el) => el.expirationDate != null);
    final List<DestinyItemComponent> itemComponents = [
      ...inventory,
      ...eq,
    ];
    final Map<String, DestinyItemInstanceComponent> instances = {...ins}
      ..removeWhere((k, v) => v.cannotEquipReason == 1);

    final List<int> hashes = itemComponents.map((el) => el.itemHash).toList();
    final List<DestinyInventoryItemDefinition> itemDefinitions =
        await dbRepository.getItemData(hashes);

    final List<Item> items = [];

    itemComponents.forEach((item) {
      final DestinyItemInstanceComponent instance =
          instances[item.itemInstanceId];
      if (instance != null) {
        final DestinyInventoryItemDefinition definition = itemDefinitions
            .singleWhere((d) => d.hash == item.itemHash, orElse: () => null);
        if (definition != null) {
          items.add(Item.fromResponse(item, definition, instance));
        }
      }
    });

    return sortItems(
      items,
      by: sortBy,
      orderedBy: orderBy,
    );
  }

  Future<List<Item>> _computeItemList(
    List<DestinyItemComponent> inv,
    List<DestinyItemComponent> eq,
    Map<String, DestinyItemInstanceComponent> ins, {
    @required bucketHash,
    @required int statHash,
    Order orderBy,
    int classHash,
  }) async {
    final inventory = [...inv]..removeWhere((el) => el.expirationDate != null);
    final List<DestinyItemComponent> itemComponents = [
      ...inventory,
      ...eq,
    ];
    final List<String> mustRemove = [];
    final Map<String, DestinyItemInstanceComponent> instances = {...ins}
      // ..removeWhere((k, v) => v.cannotEquipReason == 1)
      ..removeWhere((k, v) {
        if (v.primaryStat?.statHash != statHash) {
          mustRemove.add(k);
          return true;
        }
        return false;
      });

    mustRemove.forEach((s) {
      itemComponents.removeWhere((c) => c.itemInstanceId == s);
    });

    if (eq.isNotEmpty) {
      itemComponents.retainWhere((el) => el.bucketHash == bucketHash);
    }

    final List<int> hashes = itemComponents.map((el) => el.itemHash).toList();
    final List<DestinyInventoryItemDefinition> itemDefinitions =
        await dbRepository.getItemData(hashes)
          ..retainWhere((d) => d.inventory.bucketTypeHash == bucketHash);

    final List<Item> items = [];

    if (classHash != null) {
      itemDefinitions.removeWhere(
        (d) => !d.itemCategoryHashes.contains(classHash),
      );
    }

    itemComponents.forEach((item) {
      final DestinyItemInstanceComponent instance =
          instances[item.itemInstanceId];

      if (instance != null) {
        final DestinyInventoryItemDefinition definition = itemDefinitions
            .singleWhere((d) => d.hash == item.itemHash, orElse: () => null);
        if (definition != null) {
          items.add(Item.fromResponse(item, definition, instance));
        }
      }
    });

    items.sort(
      (i1, i2) => safelyCompare.numbers(i2.primaryStat, i1.primaryStat),
    );

    return items;
  }
}
