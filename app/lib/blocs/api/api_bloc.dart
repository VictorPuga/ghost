import 'dart:async';
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
        components: [DestinyComponentType.characters],
      );

      final List<CharacterComponent> characterList =
          profileResponse.characters.values.toList();
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
          DestinyComponentType.characterInventories,
          DestinyComponentType.characterEquipment,
          DestinyComponentType.itemInstances,
        ],
      );

      final inventory = characterResponse.inventory
        ..removeWhere((el) => el.expirationDate != null);

      final List<ItemComponent> itemComponents = [
        ...inventory,
        ...characterResponse.equipment,
      ];
      final Map<String, InstanceComponent> instances = characterResponse
          .itemComponents.instances
        ..removeWhere((k, v) => v.canEquip == false);

      final List<int> hashes = itemComponents.map((el) => el.itemHash).toList();
      final List<ItemDefinition> itemDefinitions =
          await dbRepository.getItemData(hashes);

      final List<Item> items = [];
      instances.forEach((id, instance) {
        final ItemComponent item =
            itemComponents.firstWhere((el) => el.itemInstanceId == id);
        // final InstanceComponent instance = instances[item.itemInstanceId];
        final ItemDefinition definition =
            itemDefinitions.singleWhere((d) => d.hash == item.itemHash);

        items.add(Item.fromResponse(item, definition, instance));
      });

      SortedItems sortedItems;

      final Map<int, List<Item>> sorted = sortItems(
        items,
        by: event.sortBy,
        //orderedBy: event.orderBy,
      );

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
        items: items,
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
          items: prevState.items,
          sortedItems: SortedItems(
            categories: sorted.categories,
            items: newItems,
          ),
        );
      } else {
        // TODO: Implement APITransferError.
        print('Error equipping item. Code: $code');
        yield APICharacter(
          items: prevState.items,
          sortedItems: prevState.sortedItems,
          error: 'Error code $code',
        );
      }
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
          DestinyComponentType.characters,
          DestinyComponentType.characterInventories,
          DestinyComponentType.characterEquipment,
          DestinyComponentType.itemInstances,
        ],
      );

      var sortedItems = SortedItems<Character>(
        categories: <int, Character>{},
        items: <int, List<Item>>{},
      );

      final Map<String, InstanceComponent> instances = profileResponse
          .itemComponents.instances
        ..removeWhere((k, v) => v.canEquip == false);

      for (String id in profileResponse.characters.keys) {
        final inventory = profileResponse.characterInventories[id]
          ..removeWhere((el) => el.expirationDate != null);

        final List<ItemComponent> itemComponents = [
          ...inventory,
          ...profileResponse.characterEquipment[id],
        ];

        final List<int> hashes =
            itemComponents.map((el) => el.itemHash).toList();
        final List<ItemDefinition> itemDefinitions =
            await dbRepository.getItemData(hashes);

        final List<Item> items = [];

        instances.forEach((id, instance) {
          final ItemComponent item = itemComponents.firstWhere(
            (el) => el.itemInstanceId == id,
            orElse: () => null,
          );
          if (item != null) {
            final ItemDefinition definition =
                itemDefinitions.singleWhere((d) => d.hash == item.itemHash);

            items.add(Item.fromResponse(item, definition, instance));
          }
        });

        final Map<int, List<Item>> sorted = sortItems(
          items,
          by: Sorting.bucket,
          orderedBy: event.orderBy,
        );

        final CharacterComponent charComponent = profileResponse.characters[id];
        final List<CharacterData> data =
            await dbRepository.getCharacterData([charComponent]);

        final character = Character.fromResponse(charComponent, data[0]);

        sortedItems.addTo(
          num.tryParse(id),
          sorted[event.bucketHash],
          newCategory: character,
        );
      }
      yield APIAllItems(sortedItems: sortedItems);
    }

    if (event is ThrowAPIError) {
      yield APIError(error: event.error, stacktrace: event.stackTrace);
    }
  }
}
