import 'dart:async';
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
      yield APILoading();
      final Credentials credentials =
          apiRepository.parseCredentials(event.responseJson);
      final UserMembershipData membershipData =
          await apiRepository.getMembership(credentials.accessToken);
      yield APICredentials(credentials, membershipData);
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

    if (event is GetProfile) {
      yield APILoading();
      final DestinyProfileResponse profile = await apiRepository.getProfile(
        card: event.card,
        accessToken: event.accessToken,
        components: event.components,
      );
      yield APIProfile(profile);
    }

    if (event is GetCharacters) {
      assert(dbRepository != null);
      yield APILoading<APICharacters>(
        prevState: currentState is APICharacters ? currentState : null,
      );
      final DestinyProfileResponse profileResponse =
          await apiRepository.getProfile(
        card: event.card,
        accessToken: event.accessToken,
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

    if (event is GetCharacter) {
      assert(dbRepository != null);
      yield APILoading<APICharacter>(
        prevState: currentState is APICharacter ? currentState : null,
      );
      final DestinyCharacterResponse characterResponse =
          await apiRepository.getCharacter(
        card: event.card,
        accessToken: event.accessToken,
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

    if (event is EquipItem) {
      APICharacter prevState;
      SortedItems sorted;
      if (currentState is APICharacter) {
        prevState = currentState;
        sorted = prevState.sortedItems;
      }
      yield APILoading<APICharacter>(prevState: prevState);

      final int code = await apiRepository.equipItem(
        id: event.id,
        characterId: event.characterId,
        membershipType: event.membershipType,
        accessToken: event.accessToken,
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
          // items: prevState.items,
          sortedItems: prevState.sortedItems,
          error: {'code': code},
        );
      }
    }

    if (event is GetSets) {
      assert(dbRepository != null);
      yield APILoading<APICharacters>(
        prevState: currentState is GetSets ? currentState : null,
      );
      final DestinyProfileResponse profileResponse =
          await apiRepository.getProfile(
        card: event.card,
        accessToken: event.accessToken,
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

    if (event is GetAllItems) {
      assert(dbRepository != null);

      yield APILoading<APIAllItems>(
        prevState: currentState is APIAllItems ? currentState : null,
      );
      final DestinyProfileResponse profileResponse =
          await apiRepository.getProfile(
        card: event.card,
        accessToken: event.accessToken,
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

    if (event is ThrowAPIError) {
      yield APIError(error: event.error, stacktrace: event.stackTrace);
    }
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
