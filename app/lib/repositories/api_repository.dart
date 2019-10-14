import 'dart:convert';

import 'package:bungie_api/api/destiny2.dart';
import 'package:bungie_api/helpers/http.dart';
import 'package:bungie_api/models/destiny_character_response.dart';
import 'package:bungie_api/models/destiny_item_action_request.dart';
import 'package:bungie_api/models/destiny_item_set_action_request.dart';
import 'package:bungie_api/models/destiny_profile_response.dart';
import 'package:bungie_api/models/general_user.dart';
import 'package:bungie_api/models/user_info_card.dart';
import 'package:bungie_api/models/user_membership_data.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:ghost/models/models.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'package:ghost/client.dart';
import 'package:bungie_api/models/destiny_manifest.dart';
import 'package:bungie_api/api/user.dart';

class APIRepository {
  static Firestore _instance = Firestore.instance;
  static CollectionReference _setsCollection = _instance.collection('sets');

  Credentials parseCredentials(String jsonString) {
    final Map<String, dynamic> response = jsonDecode(jsonString);
    final credentials = Credentials.fromJson(response);
    return credentials;
  }

  // Future<void> refreshToken(
  //   String token,
  // ) async {
  //   await Future.delayed(Duration(seconds: 1));
  //   return 'token';
  // }

  Future<DestinyManifest> getManifest() async {
    final r = await Destiny2.getDestinyManifest(destinyClient, {});
    return r.response;
  }

  Future<GeneralUser> getUser(String membershipId) async {
    final r = await User.getBungieNetUserById(destinyClient, membershipId, {});
    return r.response;
  }

  Future<UserMembershipData> getMembership(String accessToken) async {
    final r = await User.getMembershipDataForCurrentUser(
      destinyClient,
      {'Authorization': 'Bearer ' + accessToken},
    );
    return r.response;
  }

  Future<DestinyProfileResponse> getProfile({
    @required UserInfoCard card,
    @required String accessToken,
    @required List<int> components,
  }) async {
    final r = await Destiny2.getProfile(
      destinyClient,
      components,
      card.membershipId,
      card.membershipType,
      {'Authorization': 'Bearer ' + accessToken},
    );
    return r.response;
  }

  Future<DestinyCharacterResponse> getCharacter({
    @required UserInfoCard card,
    @required String accessToken,
    @required String characterId,
    @required List<int> components,
  }) async {
    final r = await Destiny2.getCharacter(
      destinyClient,
      characterId,
      components,
      card.membershipId,
      card.membershipType,
      {'Authorization': 'Bearer ' + accessToken},
    );
    return r.response;
  }

  Future<int> equipItem({
    @required String id,
    @required String characterId,
    @required int membershipType,
    @required String accessToken,
  }) async {
    // print(id);
    // try {
    // final res =
    await Destiny2.equipItem(
      destinyClient,
      DestinyItemActionRequest.fromJson(
        {
          'itemId': id,
          'characterId': characterId,
          'membershipType': membershipType,
        },
      ),
      {'Authorization': 'Bearer ' + accessToken},
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
    @required List<String> ids,
    @required String characterId,
    @required int membershipType,
    @required String accessToken,
  }) async {
    try {
      final res = await Destiny2.equipItems(
        destinyClient,
        DestinyItemSetActionRequest.fromJson(
          {
            'itemIds': ids,
            'characterId': characterId,
            'membershipType': membershipType
          },
        ),
        {'Authorization': 'Bearer ' + accessToken},
      );
      print(res.errorCode);
      if (res.errorCode != 1) {}
    } on HttpResponse catch (e) {
      print(e.mappedBody);
      return null;
    }
    return 1;
  }

  Future<List<ItemSet>> getSets(userId) async {
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
    }
    return sets;
  }

  Future<void> createSet(
    String userId,
    String name,
    List<Item> weapons,
    List<Item> armor,
    int classCategoryHash,
    String characterId,
  ) async {
    bool hasError = false;
    final String setId = Uuid().v4();
    final List<String> ids = [
      ...weapons.map((i) => i?.itemInstanceId),
      ...armor.map((i) => i?.itemInstanceId),
    ]..removeWhere((i) => i == null);

    // try {
    await _setsCollection.document(setId).setData({
      'userId': userId,
      'setId': setId,
      'name': name,
      'classCategoryHash': classCategoryHash,
      'characterId': characterId,
      'dateCreated': DateTime.now().toIso8601String(),
      'weapons': [...weapons.map((i) => i?.toJson())],
      'armor': [...armor.map((i) => i?.toJson())],
      'itemIds': ids,
    });
    // } catch (e) {
    //   hasError = true;
    // }
    if (!hasError) {}
  }

  Future<void> deleteSet(String setId) async {
    await _setsCollection.document(setId).delete();
  }
}
