import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/widgets/helpers/user_provider.dart';
import 'package:ghost/widgets/ui/item_column.dart';

class SelectItems extends StatefulWidget {
  final String name;
  final String characterId;
  final int classCategoryHash;
  final String setId;
  final List<Item> initialWeapons;
  final List<Item> initialArmor;
  final APIRepository _apiRepository;

  SelectItems({
    Key key,
    this.name,
    this.characterId,
    this.classCategoryHash,
    this.setId,
    this.initialWeapons,
    this.initialArmor,
  })  : _apiRepository = APIRepository(),
        super(key: key);
  @override
  _SelectItemsState createState() => _SelectItemsState();
}

class _SelectItemsState extends State<SelectItems> {
  String get _name => widget.name;
  String get _characterId => widget.characterId;
  int get _classCategoryHash => widget.classCategoryHash;

  String get _setId => widget.setId;
  List<Item> get _initialWeapons => widget.initialWeapons;
  List<Item> get _initialArmor => widget.initialArmor;

  APIRepository get _apiRepository => widget._apiRepository;

  String _userId;
  List<List<Item>> _data = [];

  @override
  void initState() {
    super.initState();
    _data = [
      _initialWeapons ?? [null, null, null],
      _initialArmor ?? [null, null, null, null, null],
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userId = UserProvider.of(context).userInfoCard.membershipId;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'Back',
        middle: Text(_name),
        trailing: CupertinoButton(
          child: const Text('Done'),
          padding: const EdgeInsets.all(0),
          onPressed: () {
            if (_setId == null) {
              _save(context);
            } else {
              _update(context);
            }
          },
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ItemColumn(
                bucketHashes: [
                  DestinyBucketHash.kinetic,
                  DestinyBucketHash.energy,
                  DestinyBucketHash.power,
                ],
                statHash: DestinyStatHash.attack,
                data: _data[0],
                onSelect: (item, i) => _select(0, item, i),
              ),
            ),
            Expanded(
              child: ItemColumn(
                characterId: _characterId,
                disabled: _characterId == null,
                classCategoryHash: _classCategoryHash,
                bucketHashes: [
                  DestinyBucketHash.head,
                  DestinyBucketHash.arms,
                  DestinyBucketHash.body,
                  DestinyBucketHash.legs,
                  DestinyBucketHash.classItem,
                ],
                statHash: DestinyStatHash.defense,
                data: _data[1],
                onSelect: (item, i) => _select(1, item, i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _select(int statI, Item item, int i) {
    final List<List<Item>> oldData = [
      [..._data[0]],
      [..._data[1]],
    ];
    oldData[statI][i] = item;
    setState(() {
      _data = oldData;
    });
  }

  _save(BuildContext context) async {
    try {
      final ItemSet newSet = await _apiRepository.createSet(
        _userId,
        _name,
        _data[0].map((i) => i?.itemInstanceId).toList(),
        _data[1].map((i) => i?.itemInstanceId).toList(),
        _classCategoryHash,
        _characterId,
      );
      // Navigator.of(context).popUntil((Route route) => route.isFirst);
      Navigator.of(context)
        ..pop()
        ..pop(
          newSet,
        );
    } catch (e) {
      throw e;
    }
  }

  _update(BuildContext context) async {
    if (_data[0] != _initialWeapons || _data[1] != _initialArmor) {
      await _apiRepository.updateSet(
        setId: _setId,
        weapons: _data[0].map((i) => i?.itemInstanceId).toList(),
        armor: _data[1].map((i) => i?.itemInstanceId).toList(),
      );
    }
    Navigator.of(context).pop<Map<String, List<String>>>(
      {
        'weapons': _data[0].map((i) => i?.itemInstanceId).toList(),
        'armor': _data[1].map((i) => i?.itemInstanceId).toList(),
      },
    );
  }
}
