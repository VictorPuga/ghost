import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/db_repository.dart';
import 'package:ghost/widgets/ui/add_item.dart';
import 'package:ghost/widgets/ui/item_card.dart';
import 'package:ghost/widgets/ui/item_list.dart';

class ItemColumn extends StatefulWidget {
  final int itemCount;
  final bool disabled;
  final List<int> bucketHashes;
  ItemColumn({
    Key key,
    this.itemCount = 3,
    @required this.bucketHashes,
    this.disabled = false,
  })  : assert(
          bucketHashes.length == itemCount,
          'The `bucketHashes` must be the same as the items displayed',
        ),
        super(key: key);

  @override
  _ItemColumnState createState() => _ItemColumnState();
}

class _ItemColumnState extends State<ItemColumn> {
  List _selectedItems;
  int get _itemCount => widget.itemCount;
  List<int> get _bucketHashes => widget.bucketHashes;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.filled(widget.itemCount, null);
  }

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
    final bool empty = _selectedItems[i] == null;
    return Expanded(
      flex: 2,
      child: empty
          ? AddItem(onPressed: () async => await _navigate(ctx, i))
          : ItemCard(onPressed: (_) async => await _navigate(ctx, i)),
    );
  }

  Future<void> _navigate(BuildContext context, int i) async {
    final dbRepository = DBRepository();
    final data = await dbRepository.getBucketData([_bucketHashes[i]]);
    final Item selected = await Navigator.of(context).push<Item>(
      CupertinoPageRoute(
        builder: (_) => ItemList(
          title: data.values.first.name,
          onSelect: (BuildContext c, Map s) {
            Navigator.of(c).pop(s);
          },
        ),
      ),
    );
    print(selected);
  }
}

class ItemColumnController {}
