import 'package:bungie_api/models/user_membership_data.dart';
import 'package:equatable/equatable.dart';
import 'package:ghost/models/models.dart';

abstract class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class AuthUninitialized extends AuthState {
  @override
  String toString() => 'AuthUninitialized';
}

class AuthAuthenticated extends AuthState {
  final Credentials credentials;

  final UserMembershipData membershipData;
  AuthAuthenticated(this.credentials, this.membershipData)
      : super([credentials, membershipData]);

  @override
  String toString() =>
      'AuthAuthenticated { credentials: ${credentials.toString().substring(0, 40)}..., membershipData: ${membershipData.toString().substring(0, 40)}... }';
}

class AuthUnauthenticated extends AuthState {
  @override
  String toString() => 'AuthUnauthenticated';
}

class AuthLoading extends AuthState {
  final String status;

  AuthLoading([this.status]) : super([status]);

  @override
  String toString() => '''AuthLoading {
    status: $status
  }''';
}

class AuthError extends AuthState {
  final String error;
  final StackTrace trace;
  AuthError(this.error, [this.trace]) : super([error, trace]);

  @override
  String toString() => '''AuthError {
    error: $error,
    trace: $trace 
  }''';
}
