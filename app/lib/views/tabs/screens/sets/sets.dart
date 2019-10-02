import 'package:bungie_api/models/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/widgets/helpers/user_provider.dart';
import 'package:ghost/widgets/ui/refresh_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'select_configs.dart';

class Sets extends StatefulWidget {
  Sets({Key key}) : super(key: key);
  @override
  _SetsState createState() => _SetsState();
}

class _SetsState extends State<Sets> {
  APIBloc _apiBloc;
  RefreshController _refreshController;

  Credentials _credentials;
  UserInfoCard _infoCard;

  @override
  void initState() {
    super.initState();
    _apiBloc = APIBloc(
      apiRepository: APIRepository(),
      dbRepository: DBRepository(),
    );
    _refreshController = RefreshController(initialRefresh: true);
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
        middle: const Text('Sets'),
        // leading: CupertinoButton(
        //   padding: EdgeInsets.only(),
        //   child: Icon(CupertinoIcons.circle_filled, size: 30),
        //   onPressed: () {
        //     print('filter');
        //   },
        // ),
        trailing: BlocBuilder(
          bloc: _apiBloc,
          builder: (BuildContext context, APIState state) {
            return CupertinoButton(
              pressedOpacity: 0.7,
              padding: const EdgeInsets.only(),
              child: const Icon(CupertinoIcons.add, size: 30),
              onPressed: () {
                if (state is APISets) {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => SelectConfigs(
                        characterIds: state.characterIds,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<APIEvent, APIState>(
          bloc: _apiBloc,
          builder: (BuildContext context, APIState state) {
            if (state is APISets) {
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
                    return Container();
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
    );
  }

  _onRefresh() {
    _apiBloc.dispatch(
      GetSets(
        accessToken: _credentials.accessToken,
        card: _infoCard,
      ),
    );
  }

  _buildItem(_, __, ___) {
    return Container();
  }
}
