import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/widgets/ui/add_item.dart';
import 'package:ghost/widgets/ui/item_card.dart';
import 'package:ghost/widgets/ui/item_list.dart';

class ItemColumn extends StatelessWidget {
  final bool disabled;
  final List<int> bucketHashes;
  final String characterId;
  final int statHash;
  final int classCategoryHash;
  final List data;
  final void Function(Item, int) onSelect;

  ItemColumn({
    Key key,
    @required this.bucketHashes,
    this.disabled = false,
    this.characterId,
    this.statHash,
    this.classCategoryHash,
    this.data,
    this.onSelect,
  }) : super(key: key);

  int get _itemCount => bucketHashes.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: _itemCount == 5 ? 1 : 3,
          child: Container(height: 0),
        ),
        for (int i = 0; i < _itemCount; i++) _item(context, i),
        Flexible(
          flex: _itemCount == 5 ? 1 : 3,
          child: Container(height: 0),
        ),
      ],
    );
  }

  Widget _item(BuildContext ctx, int i) {
    final bool empty = data[i] == null;
    return Expanded(
      flex: 2,
      child: empty
          ? AddItem(onPressed: () async => await _navigate(ctx, i))
          : ItemCard(
              item: data[i],
              onPressed: (_) async => await _navigate(ctx, i),
            ),
    );
  }

  Future<void> _navigate(BuildContext context, int i) async {
    final dbRepository = DBRepository();
    final data = await dbRepository.getBucketData([bucketHashes[i]]);

    final Item selectedItem = await Navigator.of(context).push<Item>(
      CupertinoPageRoute(
        builder: (_) => ItemList(
          title: data.values.first.name,
          bucket: data.values.toList()[0],
          characterId: characterId,
          statHash: statHash,
          classCategoryHash: classCategoryHash,
          onSelect: (BuildContext c, Item s) {
            Navigator.of(c).pop(s);
          },
        ),
      ),
    );

    onSelect(selectedItem, i);
  }
}
