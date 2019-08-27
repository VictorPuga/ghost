import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/utils.dart';
import 'package:ghost/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ItemList extends StatefulWidget {
  final String title;
  final void Function(BuildContext, Map) onSelect;

  ItemList({
    Key key,
    this.title,
    this.onSelect,
  }) : super(key: key);

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  String get _title => widget.title;
  Function get _onSelect => widget.onSelect;

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
        middle: Text(_title),
      ),
      child: SafeArea(
        child: BlocBuilder<APIEvent, APIState>(
          bloc: _apiBloc,
          builder: (BuildContext context, APIState state) {
            if (state is APIAllItems) {
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
                  var category = Character();
                  List<Item> items = [Item()];

                  if (state is InitialAPIState ||
                      (state is APILoading && state.prevState == null)) {}
                  if (state.hasError) {}
                  if (state is APILoading &&
                      state.prevState != null &&
                      state.prevState is APIAllItems) {
                    final prevState = state.prevState as APIAllItems;
                    final MapEntry<int, Character> c =
                        prevState.sortedItems.categories.entries.toList()[i];
                    category = c.value;
                    items = prevState.sortedItems.items[c.key];
                  }
                  if (state is APIAllItems) {
                    final MapEntry<int, Character> c =
                        state.sortedItems.categories.entries.toList()[i];
                    category = c.value;
                    items = state.sortedItems.items[c.key];
                  }

                  return Column(
                    children: <Widget>[
                      Text(category.className ?? ''),
                      ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, int _i) {
                          if (state is InitialAPIState ||
                              (state is APILoading &&
                                  state.prevState == null)) {
                            return Container(
                                color: Colors.red, height: 10, width: 10);
                          }
                          if (state.hasError) {
                            return i == 0 ? Text('error') : Container();
                          }
                          if (state is APILoading) {
                            return _row(context, items[_i]);
                          }
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
    return Container(
      color: Colors.blue,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 10,
              color: Colors.green,
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
              child: Text(item.name),
            ),
          ),
          CupertinoButton(
            child: Text('press'),
            onPressed: () => _onSelect(context, item),
          )
        ],
      ),
    );
  }

  void _onRefresh() {
    _apiBloc.dispatch(
      GetAllItems(
        card: _infoCard,
        accessToken: _credentials.accessToken,
        bucketHash: DestinyBucketHash.classItem,
        orderBy: Order.levelAsc,
      ),
    );
  }
}
