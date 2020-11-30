import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/custom_theme.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/widgets/ui/item_card.dart';

class ItemRow extends StatefulWidget {
  final String section;
  final List<Item> items;
  final void Function(Item) onPressed;
  final void Function(Item) onLongPressed;
  final bool showEquipped;

  ItemRow({
    Key key,
    @required this.section,
    this.items = const [],
    this.onPressed,
    this.onLongPressed,
    this.showEquipped = false,
  })  : assert(items != null),
        super(key: key);
  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  String get _section => widget.section;
  List<Item> get _items => widget.items;
  void Function(Item) get _onPressed => widget.onPressed;
  void Function(Item) get _onLongPressed => widget.onLongPressed;
  bool get showEquipped => widget.showEquipped;

  @override
  Widget build(BuildContext context) {
    Item item;
    List<Item> rest = [null, null, null];
    if (_items.isNotEmpty) {
      if (showEquipped && _items.where((i) => i.isEquiped).length == 1) {
        item = _items.singleWhere((i) => i.isEquiped);
        rest = _items.where((i) => !i.isEquiped).toList();
      } else if (!showEquipped) {
        item = _items.first;
        rest = _items.sublist(1);
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Text(
                  _section,
                  style: CustomTheme.headingStyle,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: ItemCard(
                  item: item,
                  onPressed: _onPressed,
                  onLongPressed: _onLongPressed,
                ),
              ),
              Flexible(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rest.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (_, i) {
                      return ItemCard(
                        item: rest[i],
                        onPressed: _onPressed,
                        onLongPressed: _onLongPressed,
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
