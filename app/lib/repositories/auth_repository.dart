import 'dart:convert';
import 'package:ghost/models/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  static final _storage = FlutterSecureStorage();

  Future<void> saveCredentials(
    Credentials credentials,
  ) async {
    await _storage.write(key: 'credentials', value: credentials.toJsonString());
  }

  Future<void> deleteCredentials() async {
    await _storage.delete(key: 'credentials');
  }

  Future<bool> hasCredentials() async {
    final dynamic credentialsString = await _storage.read(key: 'credentials');
    if (credentialsString != null) {
      final credentials = Credentials.fromJson(jsonDecode(credentialsString));
      return credentials.accessTokenIsActive;
    }
    return false;
  }

  Future<Credentials> getCredentials() async {
    final String credentialsString = await _storage.read(key: 'credentials');
    final credentials = Credentials.fromJson(jsonDecode(credentialsString));
    return credentials;
  }
}
