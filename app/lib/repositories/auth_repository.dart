import 'dart:convert';
import 'package:ghost/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  Future<void> saveCredentials(
    Credentials credentials,
  ) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: 'credentials', value: credentials.toJsonString());
    // await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> deleteCredentials() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: 'credentials');
    return;
  }

  // Future<void> persistToken(String token) async {
  //   /// write to keystore/keychain
  //   await Future.delayed(Duration(seconds: 1));
  //   return;
  // }

  Future<bool> hasCredentials() async {
    final storage = FlutterSecureStorage();
    final dynamic credentialsString = await storage.read(key: 'credentials');
    if (credentialsString != null) {
      final Map<String, dynamic> credentialsJson =
          jsonDecode(credentialsString);
      final credentials = Credentials.fromJson(credentialsJson);
      return credentials.accessTokenIsActive;
    }
    return false;
  }

  Future<Credentials> getCredentials() async {
    final storage = FlutterSecureStorage();
    final String credentialsString = await storage.read(key: 'credentials');
    final Map<String, dynamic> credentialsJson = jsonDecode(credentialsString);
    final credentials = Credentials.fromJson(credentialsJson);
    return credentials;
  }
}
