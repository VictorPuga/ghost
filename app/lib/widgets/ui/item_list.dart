import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:bungie_api/models/user_info_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/custom_theme.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/utils.dart';
import 'package:ghost/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ItemList extends StatefulWidget {
  final String title;
  final void Function(BuildContext, Item) onSelect;
  final Bucket bucket;
  final String characterId;
  final int statHash;
  final int classCategoryHash;

  ItemList({
    Key key,
    this.title,
    this.onSelect,
    this.bucket,
    this.characterId,
    this.statHash,
    this.classCategoryHash,
  }) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  String get _title => widget.title;
  Function get _onSelect => widget.onSelect;
  Bucket get _bucket => widget.bucket;
  int get _statHash => widget.statHash;
  String get _characterId => widget.characterId;
  int get _classCategoryHash => widget.classCategoryHash;

  APIBloc _apiBloc;
  RefreshController _refreshController;
  Credentials _credentials;
  GroupUserInfoCard _infoCard;

  @override
  void initState() {
    super.initState();

    _refreshController = RefreshController(initialRefresh: true);
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
        middle: Text(_title),
      ),
      child: SafeArea(
        child: BlocBuilder<APIEvent, APIState>(
          bloc: _apiBloc,
          builder: (BuildContext context, APIState state) {
            int itemCount = 0;
            if (state is APIAllItems) {
              _refreshController.refreshCompleted();
              itemCount = state.sortedItems.categories.length + 1;
            }
            if (state is APILoading<APIAllItems>) {
              itemCount = state.prevState.sortedItems.categories.length + 1;
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
                itemCount: itemCount,
                itemBuilder: (BuildContext context, int i) {
                  var category = Character();
                  List<Item> items = [Item()];

                  if (state is InitialAPIState ||
                      (state is APILoading && state.prevState == null)) {}
                  if (state.hasError) {}

                  if (state is APILoading<APIAllItems>) {
                    if (i == itemCount - 1) {
                      items = state.prevState.vaultItems;
                    } else {
                      final prevState = state.prevState;
                      final MapEntry<int, Character> c =
                          prevState.sortedItems.categories.entries.toList()[i];
                      category = c.value;
                      items = prevState.sortedItems.items[c.key];
                    }
                  }
                  if (state is APIAllItems) {
                    if (i == itemCount - 1) {
                      items = state.vaultItems;
                    } else {
                      final MapEntry<int, Character> c =
                          state.sortedItems.categories.entries.toList()[i];
                      category = c.value;
                      items = state.sortedItems.items[c.key];
                    }
                  }

                  if (i == itemCount - 1) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vault', style: CustomTheme.headingStyle),
                        ListView.builder(
                          itemCount: items?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (_, int _i) {
                            if (state is InitialAPIState ||
                                (state is APILoading &&
                                    state.prevState == null)) {
                              return Container();
                            }
                            if (state.hasError) {
                              return i == 0 ? Text('error') : Container();
                            }
                            // if (state is APILoading) {
                            //   return _row(context, items[_i]);
                            // }
                            return _row(context, items[_i]);
                          },
                        ),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.className ?? '',
                        style: CustomTheme.headingStyle,
                      ),
                      ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, int _i) {
                          if (state is InitialAPIState ||
                              (state is APILoading &&
                                  state.prevState == null)) {
                            return Container();
                          }
                          if (state.hasError) {
                            return i == 0 ? Text('error') : Container();
                          }
                          // if (state is APILoading) {
                          //   return _row(context, items[_i]);
                          // }
                          return _row(context, items[_i]);
                        },
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _row(BuildContext context, Item item) {
    return CupertinoButton(
      padding: const EdgeInsets.only(),
      pressedOpacity: 0.7,
      onPressed: () => _onSelect(context, item),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.white),
            bottom: BorderSide(width: 0.5, color: Colors.white),
          ),
          // color: Colors.black,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: CupertinoColors.lightBackgroundGray,
                      child: item.icon == null || item.icon.isEmpty
                          ? LoadingImage()
                          : CachedNetworkImage(
                              fit: BoxFit.contain,
                              imageUrl: item.icon,
                              placeholder: (_, __) => Container(),
                            ),
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
                child: Column(
                  children: [
                    Text(
                      item.name ?? '',
                      style: CustomTheme.titleStyleAlternative,
                    ),
                    Text(
                      item.typeName ?? '',
                      style: CustomTheme.subtitleStyleAlternative,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                child: Row(
                  children: [
                    Expanded(child: Container()),
                    Text(
                      item.primaryStat?.toString() ?? '',
                      style: CustomTheme.lightStyle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onRefresh() {
    _apiBloc.dispatch(
      GetAllItems(
        card: _infoCard,
        bucketHash: _bucket.hash,
        orderBy: Order.levelDesc,
        statHash: _statHash,
        classCategoryHash: _classCategoryHash,
        characterId: _characterId,
      ),
    );
  }
}
