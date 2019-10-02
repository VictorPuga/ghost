import 'package:bungie_api/models/user_membership_data.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:meta/meta.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:ghost/repositories/auth_repository.dart';
import './auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final APIRepository apiRepository;

  AuthBloc({
    @required this.authRepository,
    @required this.apiRepository,
  }) : assert(authRepository != null);

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('Error on AuthBloc:');
    print(error);
    print(stacktrace);
    this.dispatch(ThrowAuthError(error.toString(), stacktrace));
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is VerifyCredentials) {
      final bool hasCredentials = await authRepository.hasCredentials();

      if (hasCredentials) {
        final Credentials credentials = await authRepository.getCredentials();
        final UserMembershipData membershipData =
            await apiRepository.getMembership(credentials.accessToken);
        yield AuthAuthenticated(credentials, membershipData);
      } else {
        yield AuthUnauthenticated();
      }
    }

    if (event is LogIn) {
      yield AuthLoading();
      await authRepository.saveCredentials(event.credentials);
      yield AuthAuthenticated(event.credentials, event.membershipData);
    }

    if (event is LogOut) {
      yield AuthLoading();
      await authRepository.deleteCredentials();
      yield AuthUnauthenticated();
    }

    if (event is SetAuthLoading) {
      yield AuthLoading();
    }

    if (event is ThrowAuthError) {
      yield AuthError(event.error, event.stackTrace);
    }
  }
}
