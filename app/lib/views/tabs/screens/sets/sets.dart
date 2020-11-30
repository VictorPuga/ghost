import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable_list_view/widgets/inherited_widgets.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/views/tabs/screens/sets/set.dart';
import 'package:ghost/widgets/helpers/user_provider.dart';
import 'package:ghost/widgets/ui/refresh_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'select_configs.dart';

import 'package:flutter_slidable_list_view/flutter_slidable_list_view.dart';

class Sets extends StatefulWidget {
  Sets({Key key}) : super(key: key);

  @override
  _SetsState createState() => _SetsState();
}

class _SetsState extends State<Sets> {
  APIBloc _apiBloc;
  RefreshController _refreshController;

  Credentials _credentials;
  GroupUserInfoCard _infoCard;
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    _textEditingController = TextEditingController(text: '');

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

    _apiBloc.apiRepository.setAccessToken(_credentials.accessToken);
  }

  @override
  void dispose() {
    _apiBloc.dispose();
    _refreshController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<APIEvent, APIState>(
      bloc: _apiBloc,
      builder: (context, APIState state) {
        // print(state.runtimeType);
        List<ItemSet> sets = [];
        List<String> characterIds = [];
        bool loading = true;
        if (state.hasError) {
          _refreshController.refreshFailed();
          loading = false;
          // return Container(child: const Text('error'));
        } else if (state is InitialAPIState ||
            (state is APILoading && state.prevState == null)) {}

        if (state is APILoading<APISets>) {
          sets = state.prevState.sets;
          characterIds = state.prevState.characterIds;
          loading = false;
        }
        if (state is APISets) {
          _refreshController.refreshCompleted();
          sets = state.sets;
          characterIds = state.characterIds;
          loading = false;
        }

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
            trailing: CupertinoButton(
              pressedOpacity: 0.7,
              padding: const EdgeInsets.only(),
              child: const Icon(CupertinoIcons.add, size: 30),
              onPressed: () async {
                if (state is APISets) {
                  final ItemSet newSet = await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (_) => SelectConfigs(
                        characterIds: state.characterIds,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                  if (newSet != null) {
                    sets.insert(0, newSet);
                    // Trigger rebuild
                    setState(() {});
                  }
                }
              },
            ),
          ),
          child: SafeArea(
            child: Builder(
              builder: (context) {
                //         // if (sets.isEmpty) {
                //         //   return const Text('You have no sets');
                //         // }
                //         // if (state is InitialAPIState ||
                //         //     (state is APILoading && state.prevState == null)) {
                //         //   return Container();
                //         // }
                //         // if (state.hasError) {
                //         //   return i == 0 ? Text('error') : Container();
                //         // }
                //         // // if (state is APILoading) {
                //         // //   return _buildItem(context, sets, i);
                //         // // }
                //         // return _buildItem(context, sets, characterIds, i);
                //       },
                //     ),
                //   ),
                // );
                return SlidingList(
                  data: sets,
                  itemBuilder: (c, i) => _buildItem(c, sets, characterIds, i),
                  emptyBuilder: (_) {
                    if (!loading) {
                      return const Text('You have no items');
                    }
                    return Container();
                  },
                  onRefresh: _onRefresh,
                  refreshController: _refreshController,
                  actionWidgetDelegate: ActionWidgetDelegate(
                    2,
                    (i) {
                      if (i == 0) {
                        return const Text(
                          'Rename',
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        return const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }
                    },
                    (a, b, item) async {
                      final itemSet = sets[a];

                      if (b == 0) {
                        _textEditingController.text = itemSet.name;

                        final String newName = await showCupertinoDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return SafeArea(
                              maintainBottomViewPadding: true,
                              child: CupertinoAlertDialog(
                                title: Text('New Name'),
                                content: CupertinoTextField(
                                  controller: _textEditingController,
                                  placeholder: "The name can't be empty",
                                  autofocus: true,
                                ),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    isDefaultAction: true,
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text('Change'),
                                    onPressed: () {
                                      if (_textEditingController
                                          .text.isNotEmpty) {
                                        Navigator.of(ctx)
                                            .pop(_textEditingController.text);
                                      }
                                    },
                                  )
                                ],
                              ),
                            );
                          },
                        );

                        if (newName != null && newName != itemSet.name) {
                          sets[a].name = newName;
                          item.close(fromSelf: true);
                          await _apiBloc.apiRepository.updateSet(
                            setId: itemSet.setId,
                            name: newName,
                          );
                        }
                      } else {
                        final bool shouldDelete = await showCupertinoDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return CupertinoAlertDialog(
                              title: Text('Are you sure you want to delete?'),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  isDefaultAction: true,
                                ),
                                CupertinoDialogAction(
                                  child: const Text('Delete'),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  isDestructiveAction: true,
                                ),
                              ],
                            );
                          },
                        );
                        // It can be null
                        if (shouldDelete == true) {
                          await Future.delayed(Duration(seconds: 3));
                          item.remove();
                          // await _apiBloc.apiRepository.deleteSet(sets[a].setId);
                        }
                      }
                    },
                    [
                      CupertinoColors.activeBlue,
                      CupertinoColors.destructiveRed,
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  _onRefresh() async {
    _apiBloc.dispatch(
      GetSets(card: _infoCard),
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
      onPressed: () async {
        await Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (_) => SetView(
              itemSet: itemSet,
              membershipType: _infoCard.membershipType,
              membershipId: _infoCard.membershipId,
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

class SlidingList extends StatefulWidget {
  final List data;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext) emptyBuilder;
  final void Function() onRefresh;
  final RefreshController refreshController;
  final ActionWidgetDelegate actionWidgetDelegate;

  static Widget _defaultBuilder(_) => Container();
  static _defaultRefresh() {}

  SlidingList({
    Key key,
    this.data = const [],
    this.itemBuilder,
    this.emptyBuilder = _defaultBuilder,
    this.onRefresh = _defaultRefresh,
    this.refreshController,
    this.actionWidgetDelegate,
  })  : assert(itemBuilder != null),
        assert(refreshController != null),
        assert(actionWidgetDelegate != null),
        super(key: key);

  @override
  _SlidingListState createState() => _SlidingListState();
}

class _SlidingListState extends State<SlidingList> {
  List get _data => widget.data;
  Widget Function(BuildContext, int) get _itemBuilder => widget.itemBuilder;
  Widget Function(BuildContext) get _emptyBuilder => widget.emptyBuilder;
  void Function() get _onRefresh => widget.onRefresh;
  RefreshController get _refreshController => widget.refreshController;
  ActionWidgetDelegate get _actionWidgetDelegate => widget.actionWidgetDelegate;

  int selected = -1;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notif) {
        if (selected != -1) {
          if (notif is ScrollStartNotification) {
            CloseNotifyManager().notify();
            setState(() {
              selected = -1;
            });
          }
        }
        return true;
      },
      child: SmartRefresher(
        enablePullDown: true,
        header: RefreshHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: _data.isEmpty
            ? _emptyBuilder(context)
            : SlidingIndexData(
                selected,
                child: ListView.builder(
                  itemCount: _data.length,
                  physics:
                      // selected == -1
                      //     ? AlwaysScrollableScrollPhysics()
                      //     :
                      NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int i) {
                    return SlideItem(
                      content: _itemBuilder(context, i),
                      slideProportion: .25,
                      indexInList: i,
                      actionWidgetDelegate: _actionWidgetDelegate,
                      supportElasticity: true,
                      slideBeginCallback: (_i) {
                        setState(() {
                          selected = _i;
                        });
                      },
                      slideUpdateCallback: (_i) {
                        setState(() {
                          selected = _i;
                        });
                      },
                      itemRemoveCallback: (_i) {
                        setState(() {
                          _data.removeAt(_i);
                        });
                      },
                      animationDuration: Duration(milliseconds: 200),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
