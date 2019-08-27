import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/blocs/api/api_state.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import './screens.dart';

class CharactersView extends StatefulWidget {
  CharactersView({Key key}) : super(key: key);
  @override
  _CharactersViewState createState() => _CharactersViewState();
}

class _CharactersViewState extends State<CharactersView> {
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
        middle: Text('Characters'),
      ),
      child: SafeArea(
        child: Center(
          child: BlocBuilder<APIEvent, APIState>(
            bloc: _apiBloc,
            builder: (BuildContext context, APIState state) {
              if (state is APICharacters) {
                _refreshController.refreshCompleted();
              }
              if (state.hasError) {
                _refreshController.refreshFailed();
              }

              return SmartRefresher(
                enablePullDown: true,
                header: RefreshHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int i) {
                    if (state is InitialAPIState ||
                        (state is APILoading && state.prevState == null)) {
                      return CharacterCard();
                    }
                    if (state.hasError) {
                      return i == 0 ? Text('error') : Container();
                    }
                    if (state is APILoading) {
                      return _buildItem(context, state.prevState, i);
                    }
                    return _buildItem(context, state, i);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onRefresh() {
    _apiBloc.dispatch(
      GetCharacters(
        card: _infoCard,
        accessToken: _credentials.accessToken,
      ),
    );
  }

  Widget _buildItem(BuildContext context, APICharacters state, int i) {
    final Character character = state.characters[i];
    return CharacterCard(
      character: character,
      onPressed: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => CharacterView(
              className: character.className,
              characterId: character.characterId,
            ),
          ),
        );
        // _refreshController.requestRefresh();
        _onRefresh();
      },
    );
  }
}
