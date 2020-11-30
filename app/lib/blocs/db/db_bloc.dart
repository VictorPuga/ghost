import 'dart:async';
import 'package:bungie_api/models/destiny_manifest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/blocs/auth/auth.dart';
import 'package:version/version.dart';

import './db.dart';

class DBBloc extends Bloc<DBEvent, DBState> {
  final DBRepository dbRepository;
  final APIRepository apiRepository;
  final AuthBloc authBloc;

  DBBloc({
    @required this.dbRepository,
    @required this.apiRepository,
    this.authBloc,
  })  : assert(dbRepository != null),
        // assert(authBloc != null),
        assert(apiRepository != null);

  factory DBBloc.withContext(
    BuildContext context, {
    @required DBRepository dbRepository,
    @required APIRepository apiRepository,
  }) {
    final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    return DBBloc(
      dbRepository: dbRepository,
      apiRepository: apiRepository,
      authBloc: authBloc,
    );
  }

  @override
  DBState get initialState => DBInitial();

  @override
  void onError(Object error, StackTrace stacktrace) {
    print('Error on DBBloc:');
    print(error);
    print(stacktrace);
    this.dispatch(ThrowDBError(error.toString(), stacktrace));
  }

  @override
  Stream<DBState> mapEventToState(
    DBEvent event,
  ) async* {
    if (event is GetManifest) {
      assert(authBloc != null);
      authBloc.dispatch(SetAuthLoading());
      // yield DBLoading();
      final DestinyManifest manifest = await apiRepository.getManifest();
      final String manifestVersion = await dbRepository.getManifestVersion();
      if (manifestVersion != null) {
        final currentVersion = Version.parse(manifest.version);
        final localVersion = Version.parse(manifestVersion);
        if (localVersion < currentVersion) {
          print('there is a new version of the manifest');
          await dbRepository.deleteOldDbs();
          await dbRepository.getDefinitionsAndAssets(manifest);
        }
      } else {
        print('getting assets');
        await dbRepository.getDefinitionsAndAssets(manifest);
      }

      authBloc.dispatch(VerifyCredentials());
    }
    if (event is ThrowDBError) {
      // yield DBError(event.error, event.stackTrace);
    }
  }
}
