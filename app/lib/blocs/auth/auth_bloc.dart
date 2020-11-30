import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:bungie_api/models/user_membership_data.dart';
import 'package:cron/cron.dart';

import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
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
      assert(apiRepository != null);
      final bool hasCredentials = await authRepository.hasCredentials();

      Cron()
        // every 50 minutes
        ..schedule(Schedule.parse('*/50 * * * *'), () async {
          try {
            final bool _hasCredentials = await authRepository.hasCredentials();

            if (_hasCredentials) {
              final Credentials _c = await authRepository.getCredentials();
              if (_c.refreshTokenIsActive) {
                final Credentials _newCredentials =
                    await apiRepository.refreshToken(_c.refreshToken);

                final UserMembershipData membershipData =
                    // A new instance is needed because it needs the access token
                    await APIRepository(_newCredentials.accessToken)
                        .getMembership();

                print('refreshed token');

                this.dispatch(
                  LogIn(
                    credentials: _newCredentials,
                    membershipData: membershipData,
                    isInitialLogin: false,
                  ),
                );
              }
            }
          } catch (e, s) {
            print(e);
            print(s);
          }
        });

      if (hasCredentials) {
        final Credentials credentials = await authRepository.getCredentials();
        if (credentials.accessTokenIsActive) {
          final UserMembershipData membershipData =
              await APIRepository(credentials.accessToken).getMembership();

          yield AuthAuthenticated(credentials, membershipData);
        } else if (credentials.refreshTokenIsActive) {
          final Credentials newCredentials =
              await apiRepository.refreshToken(credentials.refreshToken);

          final UserMembershipData membershipData =
              await APIRepository(newCredentials.accessToken).getMembership();

          await authRepository.saveCredentials(newCredentials);
          yield AuthAuthenticated(newCredentials, membershipData);
        } else {
          yield AuthUnauthenticated();
        }
      } else {
        yield AuthUnauthenticated();
      }
    }

    if (event is LogIn) {
      if (event.isInitialLogin) {
        yield AuthLoading();
      }
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

    if (event is String) {
      yield AuthLoading();
    }

    if (event is ThrowAuthError) {
      yield AuthError(event.error, event.stackTrace);
    }
  }
}
