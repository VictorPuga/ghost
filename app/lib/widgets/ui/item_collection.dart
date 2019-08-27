import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/widgets/ui/item_row.dart';

class ItemCollection extends StatelessWidget {
  final String characterId;
  final List<SortedFraction> data;
  final void Function(Item) onPressed;

  ItemCollection({
    Key key,
    @required this.characterId,
    @required this.data,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          for (var i = 0; i < data.length; i++)
            ItemRow(
              section: data[i].category.name ?? '',
              items: List<Item>.from(data[i].items),
              onPressed: onPressed,
            )
        ],
      ),
    );
  }
}
