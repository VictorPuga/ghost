import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/auth/auth.dart';
import 'package:ghost/blocs/db/db.dart';
import 'package:ghost/blocs/progress/progress.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/auth_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/views/tabs/tabs.dart';
import 'package:ghost/views/views.dart';
import 'package:ghost/widgets/helpers/user_provider.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthBloc _authBloc;
  ProgressBloc _progressBloc;
  DBBloc _dbBloc;

  @override
  void initState() {
    super.initState();
    _progressBloc = ProgressBloc();
    _authBloc = AuthBloc(
      authRepository: AuthRepository(),
      apiRepository: APIRepository(),
    );

    _dbBloc = DBBloc(
      authBloc: _authBloc,
      apiRepository: APIRepository(),
      dbRepository: DBRepository(
        progressBloc: _progressBloc,
      ),
    );

    _dbBloc.dispatch(GetManifest());
    // _authBloc.dispatch(VerifyCredentials());
  }

  @override
  void dispose() {
    _authBloc.dispose();
    _progressBloc.dispose();
    _dbBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProviderTree(
      blocProviders: [
        BlocProvider<AuthBloc>(bloc: _authBloc),
        BlocProvider<ProgressBloc>(bloc: _progressBloc),
      ],
      child: CupertinoApp(
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(
          primaryColor: Colors.blue,
        ),
        home: BlocBuilder<AuthEvent, AuthState>(
          bloc: _authBloc,
          builder: (BuildContext context, AuthState state) {
            if (state is AuthUninitialized || state is AuthLoading) {
              return SplashView();
            }
            if (state is AuthAuthenticated) {
              return UserProvider(
                credentials: state.credentials,
                userInfoCard: state.membershipData.destinyMemberships[0],
                child: Tabs(),
              );
            }
            if (state is AuthUnauthenticated) {
              return LoginView();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
