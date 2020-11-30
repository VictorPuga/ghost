import 'dart:convert';

import 'package:bungie_api/api/destiny2.dart';
import 'package:bungie_api/api/user.dart';
import 'package:bungie_api/enums/destiny_component_type_enum.dart';
import 'package:bungie_api/enums/transfer_statuses_enum.dart';
import 'package:bungie_api/helpers/http.dart';
import 'package:bungie_api/models/destiny_character_response.dart';
import 'package:bungie_api/models/destiny_item_action_request.dart';
import 'package:bungie_api/models/destiny_item_response.dart';
import 'package:bungie_api/models/destiny_item_set_action_request.dart';
import 'package:bungie_api/models/destiny_item_transfer_request.dart';
import 'package:bungie_api/models/destiny_manifest.dart';
import 'package:bungie_api/models/destiny_profile_response.dart';
import 'package:bungie_api/models/general_user.dart';
import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:bungie_api/models/user_membership_data.dart';
import 'package:bungie_api/responses/destiny_item_response_response.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:ghost/utils.dart';

import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'package:ghost/client.dart';
import 'package:ghost/models/models.dart';

class APIRepository {
  static final Firestore _instance = Firestore.instance;
  static final CollectionReference _setsCollection =
      _instance.collection('sets');

  String _accessToken;
  DestinyClient _destinyClient;

  APIRepository([this._accessToken])
      : _destinyClient = DestinyClient(_accessToken);

  void setAccessToken(String newToken) {
    _accessToken = newToken;
    _destinyClient.accessToken = _accessToken;
  }

  Credentials parseCredentials(String jsonString) {
    final Map<String, dynamic> response = jsonDecode(jsonString);
    return Credentials.fromJson(response);
  }

  Future<Credentials> refreshToken(
    String token,
  ) async {
    final HttpResponse response = await _destinyClient.request(
      HttpClientConfig(
        'POST',
        'https://ghost-companion.herokuapp.com/oauth/refresh',
        null,
        {
          'token': token,
        },
      ),
    );
    return Credentials.fromJson(response.mappedBody);
  }

  Future<DestinyManifest> getManifest() async {
    final r = await Destiny2.getDestinyManifest(_destinyClient);
    return r.response;
  }

  Future<GeneralUser> getUser(String membershipId) async {
    final r = await User.getBungieNetUserById(_destinyClient, membershipId);
    return r.response;
  }

  Future<UserMembershipData> getMembership() async {
    assert(_accessToken != null);
    final r = await User.getMembershipDataForCurrentUser(_destinyClient);
    // printObject(r.response.destinyMemberships);
    return r.response;
  }

  Future<DestinyProfileResponse> getProfile({
    @required GroupUserInfoCard card,
    @required List<int> components,
  }) async {
    assert(_accessToken != null);
    final r = await Destiny2.getProfile(
      _destinyClient,
      components,
      card.membershipId,
      card.membershipType,
    );
    return r.response;
  }

  Future<DestinyCharacterResponse> getCharacter({
    @required GroupUserInfoCard card,
    @required String characterId,
    @required List<int> components,
  }) async {
    assert(_accessToken != null);
    final r = await Destiny2.getCharacter(
      _destinyClient,
      characterId,
      components,
      card.membershipId,
      card.membershipType,
    );
    return r.response;
  }

  Future<int> equipItem({
    @required String id,
    @required String characterId,
    @required int membershipType,
  }) async {
    assert(_accessToken != null);
    // try {
    await Destiny2.equipItem(
      _destinyClient,
      DestinyItemActionRequest.fromJson(
        {
          'itemId': id,
          'characterId': characterId,
          'membershipType': membershipType,
        },
      ),
    );
    // } on DioError
    // catch (e) {
    //   if (e.type == DioErrorType.RESPONSE) {
    //     // final res = BungieResponse.fromJson(jsonDecode(e.response.toString()));
    //     // return res.errorCode;
    //     return jsonDecode(e.response.toString())['ErrorCode'];
    //   }
    // }
    return 1;
  }

  Future equipItemSet({
    @required List<Item> items,
    @required String characterId,
    @required String membershipId,
    @required int membershipType,
  }) async {
    assert(_accessToken != null);
    try {
      final itemResponses = await Future.wait(
        [
          for (final Item item in items)
            getItem(
              instanceId: item.itemInstanceId,
              membershipId: membershipId,
              membershipType: membershipType,
              components: [
                DestinyComponentType.ItemCommonData,
                DestinyComponentType.ItemInstances,
              ],
            ),
        ],
      );

      if (itemResponses
          .where(
            (i) =>
                validateFlag(
                  i.item.data.transferStatus,
                  TransferStatuses.ItemIsEquipped,
                ) &&
                i.characterId != characterId,
          )
          .isNotEmpty) {
        return -1; // Item(s) equpped by other characters
      }
      if (itemResponses
          .where(
            (i) => validateFlag(
              i.item.data.transferStatus,
              TransferStatuses.NoRoomInDestination,
            ),
          )
          .isNotEmpty) {
        return -4;
      }

      // // final itemsOnCharacter =
      // //     itemResponses.where((i) => i.characterId == characterId);

      final itemsOnOtherCharacter = itemResponses
          .where((i) => i.characterId != characterId && i.characterId != null)
          .toList();

      final itemsOnVault =
          itemResponses.where((i) => i.characterId == null).toList();

      if (itemsOnOtherCharacter.isNotEmpty) {
        await transferItems(
          items: _responsesToItems(itemsOnOtherCharacter),
          characterIds:
              itemsOnOtherCharacter.map((i) => i.characterId).toList(),
          membershipId: membershipId,
          membershipType: membershipType,
          toVault: true,
        );
        await transferItems(
          items: _responsesToItems(itemsOnOtherCharacter),
          characterIds: List.filled(
            itemsOnVault.length,
            characterId,
          ),
          membershipId: membershipId,
          membershipType: membershipType,
        );
      }

      if (itemsOnVault.isNotEmpty) {
        await transferItems(
          items: _responsesToItems(itemsOnVault),
          characterIds: List.filled(
            itemsOnVault.length,
            characterId,
          ),
          membershipId: membershipId,
          membershipType: membershipType,
        );
      }
      await Destiny2.equipItems(
        _destinyClient,
        DestinyItemSetActionRequest.fromJson(
          {
            'itemIds': items.map((i) => i.itemInstanceId).toList(),
            'characterId': characterId,
            'membershipType': membershipType
          },
        ),
      );
    } on HttpResponse catch (_) {
      // print(e.mappedBody);
      return null;
    }
    return 1;
  }

  Future transferItems({
    @required List<Item> items,
    @required List<String> characterIds,
    @required String membershipId,
    @required int membershipType,
    bool toVault = false,
  }) async {
    assert(items.length == characterIds.length);
    assert(_accessToken != null);
    // try {
    await Future.wait(
      [
        for (int i = 0; i < characterIds.length; i++)
          Destiny2.transferItem(
            _destinyClient,
            DestinyItemTransferRequest.fromJson(
              {
                'itemReferenceHash': items[i].itemHash,
                'stackSize': items[i].quantity,
                'transferToVault': toVault,
                'itemId': items[i].itemInstanceId,
                'characterId': characterIds[i],
                'membershipType': membershipType,
              },
            ),
          )
      ],
    );
    // } on HttpResponse catch (_) {
    //   // If the item is already on the character, an error is thrown.
    //   // We ignore that.
    // }
  }

  Future<DestinyItemResponse> getItem({
    @required String instanceId,
    @required String membershipId,
    @required int membershipType,
    List<int> components = const [DestinyComponentType.ItemCommonData],
  }) async {
    assert(_accessToken != null);
    final DestinyItemResponseResponse r = await Destiny2.getItem(
      _destinyClient,
      components,
      membershipId,
      instanceId,
      membershipType,
    );
    return r.response;
  }

  Future<List<ItemSet>> getSets(String userId) async {
    List<ItemSet> sets = [];
    QuerySnapshot r;
    bool hasError = false;
    // try {
    r = await _setsCollection
        .where('userId', isEqualTo: userId)
        .limit(10)
        .getDocuments();
    // } catch (e) {
    //   // TODO: Handle error state
    //   print(e);
    //   hasError = true;
    // }
    if (!hasError && r.documents.isNotEmpty) {
      r.documents.forEach((DocumentSnapshot doc) {
        final itemSet = ItemSet.fromJson(doc.data);
        sets.add(itemSet);
      });
      sets.sort((el1, el2) => el2.dateCreated.compareTo(el1.dateCreated));
    }
    return sets;
  }

  Future<ItemSet> createSet(
    String userId,
    String name,
    List<String> weapons,
    List<String> armor,
    int classCategoryHash,
    String characterId,
  ) async {
    bool hasError = false;
    final String setId = Uuid().v4();
    final DateTime dateCreated = DateTime.now();

    // try {
    await _setsCollection.document(setId).setData({
      'userId': userId,
      'setId': setId,
      'name': name.trim(),
      'classCategoryHash': classCategoryHash,
      'characterId': characterId,
      'dateCreated': dateCreated.toIso8601String(),
      'weapons': [...weapons],
      'armor': [...armor],
    });
    // } catch (e) {
    //   hasError = true;
    // }
    if (!hasError) {
      return ItemSet(
        userId: userId,
        setId: setId,
        name: name.trim(),
        classCategoryHash: classCategoryHash,
        characterId: characterId,
        dateCreated: dateCreated,
        weapons: weapons,
        armor: armor,
      );
    }
    return null;
  }

  Future<void> updateSet({
    @required String setId,
    String name,
    List<String> weapons,
    List<String> armor,
  }) async {
    // bool hasError = false;

    await _setsCollection.document(setId).updateData({
      if (name != null) 'name': name.trim(),
      if (weapons != null) 'weapons': [...weapons],
      if (armor != null) 'armor': [...armor],
    });
  }

  Future<void> deleteSet(String setId) async {
    await _setsCollection.document(setId).delete();
  }

  List<Item> _responsesToItems(List<DestinyItemResponse> items) => items
      .map(
        (i) => Item(
          itemHash: i?.item?.data?.itemHash,
          quantity: i?.item?.data?.quantity,
          itemInstanceId: i?.item?.data?.itemInstanceId,
        ),
      )
      .toList();
}
