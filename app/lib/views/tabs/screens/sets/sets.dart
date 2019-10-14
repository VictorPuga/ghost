import 'package:bungie_api/models/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/views/tabs/screens/sets/set.dart';
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
            List<ItemSet> sets = [];
            List<String> characterIds = [];
            if (state.hasError) {
              _refreshController.refreshFailed();
              // return Container(child: const Text('error'));
            } else if (state is InitialAPIState ||
                (state is APILoading && state.prevState == null)) {}

            if (state is APILoading<APISets>) {
              sets = state.prevState.sets;
              characterIds = state.prevState.characterIds;
            }
            if (state is APISets) {
              _refreshController.refreshCompleted();
              sets = state.sets;
              characterIds = state.characterIds;
            }

            return SmartRefresher(
              enablePullDown: true,
              header: RefreshHeader(),
              controller: _refreshController,
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: sets.isNotEmpty ? sets.length : 1,
                itemBuilder: (BuildContext context, int i) {
                  if (sets.isEmpty) {
                    return const Text('You have no items');
                  }
                  if (state is InitialAPIState ||
                      (state is APILoading && state.prevState == null)) {
                    return Container();
                  }
                  if (state.hasError) {
                    return i == 0 ? Text('error') : Container();
                  }
                  // if (state is APILoading) {
                  //   return _buildItem(context, sets, i);
                  // }
                  return _buildItem(context, sets, characterIds, i);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  _onRefresh() async {
    _apiBloc.dispatch(
      GetSets(
        accessToken: _credentials.accessToken,
        card: _infoCard,
      ),
    );
  }

  _buildItem(
    BuildContext context,
    List<ItemSet> sets,
    List<String> characterIds,
    int i,
  ) {
    final itemSet = sets[i];
    return CupertinoButton(
      padding: const EdgeInsets.all(0),
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      pressedOpacity: 0.8,
      onPressed: () {
        // print(itemSet.setId);
        // APIRepository().deleteSet(itemSet.setId);
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => SetView(
              itemSet: itemSet,
              membershipType: _infoCard.membershipType,
              accessToken: _credentials.accessToken,
              characterIds: characterIds,
            ),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            // top: BorderSide(width: 0.5, color: Colors.black12),
            bottom: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: <Widget>[
              Text(itemSet.name ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
