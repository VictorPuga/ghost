import 'dart:ui';

import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:bungie_api/models/user_info_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  GroupUserInfoCard _infoCard;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshController.requestRefresh();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = UserProvider.of(context);

    if (provider.credentials.accessToken != _credentials?.accessToken) {
      _apiBloc = APIBloc(
        apiRepository: APIRepository(
          provider.credentials.accessToken,
        ),
        dbRepository: DBRepository(),
      );
    }

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
          child: BlocBuilder<APIEvent, APIState>(
            bloc: _apiBloc,
            builder: (BuildContext context, APIState state) {
              SortedItems inventory;
              if (state.hasError || state is APIError) {
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
              return CharacterSection(
                refreshController: _refreshController,
                onRefresh: _onRefresh,
                characterId: _characterId,
                inventory: inventory,
                onPressed: _onPressed,
              );
            },
          ),
        ),
      ),
    );
  }

  void _onRefresh() {
    _apiBloc.dispatch(
      GetCharacter(
        card: _infoCard,
        characterId: _characterId,
        sortBy: Sorting.bucket,
      ),
    );
  }

  void _onPressed(Item item) {
    _apiBloc.dispatch(
      EquipItem(
        id: item.itemInstanceId,
        characterId: _characterId,
        membershipType: _infoCard.membershipType,
      ),
    );
  }
}

class CharacterSection extends StatefulWidget {
  final RefreshController refreshController;
  final VoidCallback onRefresh;
  final String characterId;
  final SortedItems inventory;
  final void Function(Item) onPressed;

  CharacterSection({
    Key key,
    this.refreshController,
    this.onRefresh,
    this.characterId,
    this.inventory,
    this.onPressed,
  }) : super(key: key);
  @override
  _CharacterSectionState createState() => _CharacterSectionState();
}

class _CharacterSectionState extends State<CharacterSection> {
  RefreshController get _refreshController => widget.refreshController;
  VoidCallback get _onRefresh => widget.onRefresh;
  String get _characterId => widget.characterId;
  SortedItems get _inventory => widget.inventory;
  void Function(Item) get _onPressed => widget.onPressed;

  PageController _pageController;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultValue = SortedFraction<Bucket>(
      category: Bucket(),
      items: [
        Item(),
        Item(),
        Item(),
        Item(),
      ],
    );

    List<List<SortedFraction>> data = [
      [defaultValue, defaultValue, defaultValue],
      [defaultValue, defaultValue, defaultValue, defaultValue, defaultValue],
    ];

    if (_inventory != null) {
      data = [
        [
          _inventory[DestinyBucketHash.kinetic],
          _inventory[DestinyBucketHash.energy],
          _inventory[DestinyBucketHash.power],
        ],
        [
          _inventory[DestinyBucketHash.head],
          _inventory[DestinyBucketHash.arms],
          _inventory[DestinyBucketHash.body],
          _inventory[DestinyBucketHash.legs],
          _inventory[DestinyBucketHash.classItem],
        ]
      ];
    }

    return Stack(
      children: [
        PageView(
          controller: _pageController,
          onPageChanged: (v) {
            setState(() {
              _selected = v;
            });
          },
          children: [
            for (var i = 0; i < data.length; i++)
              Column(
                key: PageStorageKey(i),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 45),
                  Expanded(
                    child: SmartRefresher(
                      enablePullDown: true,
                      header: RefreshHeader(),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                ItemCollection(
                                  characterId: _characterId,
                                  data: data[i],
                                  onPressed: _onPressed,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 10),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 8),
                    child: CupertinoSegmentedControl(
                      groupValue: _selected,
                      children: const {
                        0: Text('Weapons'),
                        1: Text('Armor'),
                      },
                      onValueChanged: (v) {
                        _pageController.animateToPage(
                          v,
                          duration: Duration(milliseconds: 800),
                          // curve: Curves.fastLinearToSlowEaseIn,
                          curve: Curves.fastOutSlowIn,
                        );
                        setState(() {
                          _selected = v;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
