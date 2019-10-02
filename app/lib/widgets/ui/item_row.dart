import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/custom_theme.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/widgets/ui/item_card.dart';

class ItemRow extends StatefulWidget {
  final String section;
  final List<Item> items;
  final void Function(Item) onPressed;
  ItemRow({
    Key key,
    @required this.section,
    this.items = const [],
    this.onPressed,
  })  : assert(items != null),
        super(key: key);
  @override
  _ItemRowState createState() => _ItemRowState();
}

class _ItemRowState extends State<ItemRow> {
  String get _section => widget.section;
  List<Item> get _items => widget.items;
  void Function(Item) get _onPressed => widget.onPressed;

  @override
  Widget build(BuildContext context) {
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
                  item: _items.length != 0 ? _items[0] : null,
                ),
              ),
              Flexible(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _items.length - 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (_, i) {
                      return ItemCard(
                        item: _items[i + 1],
                        onPressed: _onPressed,
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
