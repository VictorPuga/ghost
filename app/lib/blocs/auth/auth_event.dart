import 'package:bungie_api/models/user_membership_data.dart';
import 'package:ghost/models/models.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class VerifyCredentials extends AuthEvent {
  @override
  String toString() => 'VerifyCredentials';
}

class ThrowAuthError extends AuthEvent {
  final String error;
  final StackTrace stackTrace;
  ThrowAuthError(this.error, [this.stackTrace]);

  @override
  String toString() => '''
      ThrowAuthError {
        error: $error,
        stackTrace: $stackTrace 
      }
      ''';
}

class LogIn extends AuthEvent {
  final Credentials credentials;
  final UserMembershipData membershipData;

  LogIn({@required this.credentials, @required this.membershipData})
      : super([credentials, membershipData]);

  @override
  String toString() =>
      'LogIn { credentials: ${credentials.toString().substring(0, 40)}..., membershipData: ${membershipData.toString().substring(0, 40)}... }';
}

class LogOut extends AuthEvent {
  @override
  String toString() => 'LogOut';
}

class GetCredentials extends AuthEvent {
  @override
  String toString() => 'GetCredentials';
}

class SetAuthLoading extends AuthEvent {
  @override
  String toString() => 'SetAuthLoading';
}
