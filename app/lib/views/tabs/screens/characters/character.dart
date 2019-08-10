import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/blocs/api/api_state.dart';

import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';

import 'package:ghost/utils.dart';
import 'package:ghost/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CharacterView extends StatefulWidget {
  final String characterId;
  final String className;

  CharacterView({
    Key key,
    this.characterId,
    this.className,
  }) : super(key: key);
  @override
  _CharactersViewState createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharacterView> {
  String get _characterId => widget.characterId;
  String get _className => widget.className;

  APIBloc _apiBloc;
  RefreshController _refreshController;
  Credentials _credentials;
  UserInfoCard _infoCard;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    _apiBloc = APIBloc(
      apiRepository: APIRepository(),
      dbRepository: DBRepository(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = UserProvider.of(context);
    _credentials = provider.credentials;
    _infoCard = provider.userInfoCard;
  }

  @override
  void dispose() {
    _apiBloc.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(capitalize(_className)),
      ),
      child: SafeArea(
        child: Center(
          child: BlocProvider(
            bloc: _apiBloc,
            child: BlocBuilder<APIEvent, APIState>(
              bloc: _apiBloc,
              builder: (BuildContext context, APIState state) {
                SortedItems inventory;
                if (state.hasError) {
                  _refreshController.refreshFailed();
                  showBasicAlert(context, 'Error', state.error);
                  // return Text('error');
                } else if (state is InitialAPIState ||
                    (state is APILoading && state.prevState == null)) {
                } else if (state is APILoading<APICharacter>) {
                  inventory = state.prevState.sortedItems;
                } else if (state is APICharacter) {
                  inventory = state.sortedItems;
                  _refreshController.refreshCompleted();
                }

                return SmartRefresher(
                  enablePullDown: true,
                  header: RefreshHeader(),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  child: Container(
                    color: Colors.red,
                    child: ItemCollection(
                      characterId: _characterId,
                      inventory: inventory,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onRefresh() {
    _apiBloc.dispatch(
      GetCharacter(
        card: _infoCard,
        accessToken: _credentials.accessToken,
        characterId: _characterId,
        sortBy: Sorting.bucket,
      ),
    );
  }
}
