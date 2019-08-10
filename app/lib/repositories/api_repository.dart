import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/utils.dart';
import 'package:meta/meta.dart';

class APIRepository {
  static final Dio _dio = _initClient();

  static Dio _initClient() {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://www.bungie.net/platform',
      headers: {'X-API-Key': '662f235fa3ff4e11babe3ea57d1ef94f'},
    ));
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    return dio;
  }

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
    final BungieResponse response = await _get('/Destiny2/Manifest');
    final manifest = DestinyManifest.fromJson(response.data);
    return manifest;
  }

  Future<GeneralUser> getUser(String membershipId) async {
    final BungieResponse response =
        await _get('/User/GetBungieNetUserById/$membershipId');
    final user = GeneralUser.fromJson(response.data);
    return user;
  }

  Future<UserMembershipData> getMembership(String accessToken) async {
    final BungieResponse response = await _get(
      '/User/GetMembershipsForCurrentUser',
      accessToken: accessToken,
    );
    final membership = UserMembershipData.fromJson(response.data);
    return membership;
  }

  Future<DestinyProfileResponse> getProfile({
    @required UserInfoCard card,
    @required String accessToken,
    @required List<int> components,
  }) async {
    final BungieResponse response = await _get(
      '/Destiny2/${card.membershipType}/Profile/${card.membershipId}?components=${components.join(',')}',
      // This gives something like ?components%5B%5D=200
      // in version ^2.1.7 of Dio
      // queryParameters: {'components': components},
      accessToken: accessToken,
    );

    final profile = DestinyProfileResponse.fromJson(response.data);
    return profile;
  }

  Future<DestinyCharacterResponse> getCharacter({
    @required UserInfoCard card,
    @required String accessToken,
    @required String characterId,
    @required List<int> components,
  }) async {
    final BungieResponse response = await _get(
      '/Destiny2/${card.membershipType}/Profile/${card.membershipId}/Character/$characterId?components=${components.join(',')}',
      // This gives something like ?components%5B%5D=200
      // in version ^2.1.7 of Dio
      // queryParameters: {'components': components},
      accessToken: accessToken,
    );
    final characterResponse = DestinyCharacterResponse.fromJson(response.data);
    return characterResponse;
  }

  Future<int> equipItem({
    @required String id,
    @required String characterId,
    @required int membershipType,
    @required String accessToken,
  }) async {
    try {
      final BungieResponse res = await _post(
        '/Destiny2/Actions/Items/EquipItem/', // <-- Must have trailing slash!
        accessToken: accessToken,
        data: {
          'itemId': id,
          'characterId': characterId,
          'membershipType': membershipType,
        },
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        final res = BungieResponse.fromJson(jsonDecode(e.response.toString()));
        return res.errorCode;
      }
    }
    return 1;
  }

  Future<BungieResponse> _get(
    String path, {
    String accessToken,
    // Map<String, dynamic> queryParameters,
  }) async {
    final Map<String, dynamic> headers = {};
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final Response res = await _dio.get(
      path,
      // queryParameters: queryParameters,
      options: Options(headers: headers),
    );
    final BungieResponse response = _buildResponse(res);
    return response;
  }

  Future<BungieResponse> _post(
    String path, {
    dynamic data,
    String accessToken,
  }) async {
    final Response res = await _dio.post(
      path,
      data: data,
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    final BungieResponse response = _buildResponse(res);
    return response;
  }

  BungieResponse _buildResponse(Response res) {
    final response = BungieResponse.fromJson(res.data);
    // Status code is always 200 (for now)
    if (res.statusCode == 200 && response.errorCode == 1) {
      return response;
    } else {
      throw response;
    }
  }
}
