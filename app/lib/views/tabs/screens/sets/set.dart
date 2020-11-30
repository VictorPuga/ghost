import 'package:bungie_api/models/group_user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghost/blocs/api/api.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/views/tabs/screens/sets/select_items.dart';
import 'package:ghost/widgets/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SetView extends StatefulWidget {
  final ItemSet itemSet;
  final String membershipId;
  final int membershipType;
  final String accessToken;
  final List<String> characterIds;
  final APIRepository apiRepository;

  SetView({
    Key key,
    this.itemSet,
    this.membershipId,
    this.membershipType,
    this.accessToken,
    this.characterIds,
  })  : apiRepository = APIRepository(accessToken),
        super(key: key);
  @override
  _SetViewState createState() => _SetViewState();
}

class _SetViewState extends State<SetView> {
  ItemSet get _itemSet => widget.itemSet;
  String get _membershipId => widget.membershipId;
  int get _membershipType => widget.membershipType;
  String get _accessToken => widget.accessToken;
  List<String> get _characterIds => widget.characterIds;
  APIRepository get _apiRepository => widget.apiRepository;

  APIBloc _apiBloc;
  Credentials _credentials;
  GroupUserInfoCard _infoCard;
  RefreshController _refreshController;

  List<Item> _prevWeapons = [null, null, null];
  List<Item> _prevArmor = [null, null, null, null, null];

  @override
  void initState() {
    super.initState();
    _apiBloc = APIBloc(
      apiRepository: _apiRepository,
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

    _apiBloc.apiRepository.setAccessToken(_credentials.accessToken);
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return BlocBuilder<APIEvent, APIState>(
        bloc: _apiBloc,
        builder: (context, state) {
          print('bloc');
          List<Item> weapons = [];
          List<Item> armor = [];

          if (state.hasError) {
            _refreshController.refreshFailed();
          } else if (state is InitialAPIState ||
              (state is APILoading && state.prevState == null)) {
            weapons = List.filled(
              _itemSet.weapons.where((i) => i != null).length,
              Item(),
              growable: true,
            );
            armor = List.filled(
              _itemSet.armor.where((i) => i != null).length,
              Item(),
              growable: true,
            );
          }

          if (state is APILoading<APIItems>) {
            weapons = [..._prevWeapons];
            armor = [..._prevArmor];
          }
          if (state is APIItems) {
            _refreshController.refreshCompleted();
            // weapons.clear();
            // armor.clear();
            for (final id in _itemSet.weapons) {
              weapons.add(state.items[id]);
            }
            for (final id in _itemSet.armor) {
              armor.add(state.items[id]);
            }
            _prevWeapons = [...weapons];
            _prevArmor = [...armor];
            print(_prevWeapons.map((i) => i.runtimeType));
          }
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              previousPageTitle: 'Sets',
              middle: Text(_itemSet.name),
              trailing: CupertinoButton(
                padding: const EdgeInsets.all(0),
                child: const Text('Edit'),
                onPressed: () async {
                  final Map<String, List<String>> newSet =
                      await Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (c) => SelectItems(
                        name: _itemSet.name,
                        characterId: _itemSet.characterId,
                        classCategoryHash: _itemSet.classCategoryHash,
                        setId: _itemSet.setId,
                        initialWeapons: [...weapons],
                        initialArmor: [...armor],
                      ),
                    ),
                  );
                  if (newSet != null) {
                    // This also updates the itemSet in the sets array from the previous screen
                    // setState(() {
                    _itemSet.weapons = [...newSet['weapons']];
                    _itemSet.armor = [...newSet['armor']];
                    // });
                    _refreshController.requestRefresh();
                  }
                },
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    header: RefreshHeader(),
                    onRefresh: _onRefresh,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ItemCollection(
                              characterId: _itemSet.characterId,
                              // onPressed: (_) {
                              //   print('pressed');
                              // },
                              onLongPressed: (item) {
                                _onLongPress(context, item);
                              },
                              showEquipped: false,
                              data: [
                                if (!_itemSet.weapons.every((el) => el == null))
                                  SortedFraction(
                                    category: Bucket(name: 'Weapons'),
                                    items: weapons
                                        .where((i) => i != null)
                                        .toList(),
                                  ),
                                if (!_itemSet.armor.every((el) => el == null))
                                  SortedFraction(
                                    category: Bucket(name: 'Armor'),
                                    items:
                                        armor.where((i) => i != null).toList(),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: Container()),
                        CupertinoButton.filled(
                          child: const Text('Equip'),
                          onPressed: () => _equip(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _onRefresh() {
    _apiBloc.dispatch(
      GetItems(
        card: _infoCard,
        itemIds: [
          ..._itemSet.weapons,
          ..._itemSet.armor,
        ]
            .where(
              (i) => i != null,
            )
            .toList(),
      ),
    );
  }

  Future<void> _equip(BuildContext context) async {
    // if (_itemSet.classCategoryHash != null) {
    //   final result = await _apiRepository.equipItemSet(
    //     items: [
    //       ..._itemSet.weapons,
    //       ..._itemSet.armor,
    //     ].where((i) => i != null).toList(),
    //     characterId: _itemSet.characterId,
    //     membershipId: _membershipId,
    //     membershipType: _membershipType,
    //   );
    //   if (result == 1) {
    //     showBasicAlert(context, 'Success!', '');
    //   }
    //   if (result == -1) {
    //     showBasicAlert(
    //       context,
    //       'Error',
    //       'Some items are equipped by other characters. Transfer them to the vault or to the desired character first.',
    //     );
    //   }
    //   if (result == -4) {
    //     showBasicAlert(
    //       context,
    //       'Error',
    //       'There is not enough room in the character. Try to free up some space first.',
    //     );
    //   }
    // } else {}
  }

  _onLongPress(BuildContext context, Item item) {
    showCupertinoModalPopup(
      context: context,
      builder: (c) {
        return CupertinoActionSheet(
          title: Text(item.name),
          actions: [
            CupertinoActionSheetAction(
              child: Text('hey'),
              onPressed: () {
                print('lol');
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(c).pop(),
            isDefaultAction: true,
          ),
        );
      },
    );
  }
}
