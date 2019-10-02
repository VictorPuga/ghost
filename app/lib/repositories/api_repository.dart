import 'dart:convert';

import 'package:bungie_api/api/destiny2.dart';
import 'package:bungie_api/helpers/http.dart';
import 'package:bungie_api/models/destiny_character_response.dart';
import 'package:bungie_api/models/destiny_item_action_request.dart';
import 'package:bungie_api/models/destiny_profile_response.dart';
import 'package:bungie_api/models/general_user.dart';
import 'package:bungie_api/models/user_info_card.dart';
import 'package:bungie_api/models/user_membership_data.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost/models/models.dart';
import 'package:meta/meta.dart';

import 'package:ghost/clients.dart';
import 'package:bungie_api/models/destiny_manifest.dart';
import 'package:bungie_api/api/user.dart';

class APIRepository {
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
    try {
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
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        // final res = BungieResponse.fromJson(jsonDecode(e.response.toString()));
        // return res.errorCode;
        return jsonDecode(e.response.toString())['ErrorCode'];
      }
    }
    return 1;
  }

  Future<List> getSets(userId) async {
    // print();
    await airtableClient.request(HttpClientConfig('GET', '/table_1'));
    return [];
  }

  Future<void> createSet(
    String userId,
    String name,
    int classCategoryHash,
    weapons,
    armor,
  ) async {
    // print();
    await airtableClient.request(
      HttpClientConfig('POST', '/table_1', body: {
        'records': [
          {
            'fields': {
              'userId': userId,
              'classCategoryHash': classCategoryHash,
              'items': jsonEncode({
                'weapons': weapons,
                'armor': armor,
              }),
            },
          },
        ],
      }),
    );
  }

  Future<void> deleteSets(List<String> userId) async {
    // print();
    // await airtableClient.request(
    //   HttpClientConfig('POST', '/table_1', body: {
    //     'records': [
    //       {
    //         'fields': {
    //           'userId': userId,
    //           'classCategoryHash': classCategoryHash,
    //           'items': jsonEncode({
    //             'weapons': weapons,
    //             'armor': armor,
    //           }),
    //         },
    //       },
    //     ],
    //   }),
    // );
  }
}
