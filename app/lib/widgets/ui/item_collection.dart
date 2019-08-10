import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/widgets/ui/item_card.dart';

class ItemCollection extends StatelessWidget {
  final SortedItems inventory;
  final String characterId;

  ItemCollection({
    Key key,
    inventory,
    @required this.characterId,
  })  : inventory = inventory ?? SortedItems(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> defaultValue = {
      'category': Bucket(),
      'items': [],
    };
    final List<Map<String, dynamic>> data = [
      inventory[DestinyBucketHash.kinetic] ?? defaultValue,
      inventory[DestinyBucketHash.energy] ?? defaultValue,
      inventory[DestinyBucketHash.power] ?? defaultValue,
    ];
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        ItemRow(
          items: List<Item>.from(data[0]['items']),
          bucket: data[0]['category'],
          characterId: characterId,
        ),
        ItemRow(
          items: List<Item>.from(data[1]['items']),
          bucket: data[1]['category'],
          characterId: characterId,
        ),
        ItemRow(
          items: List<Item>.from(data[2]['items']),
          bucket: data[2]['category'],
          characterId: characterId,
        ),
      ],
    );
  }
}

class ItemRow extends StatelessWidget {
  final List<Item> items;
  final Bucket bucket;
  final String characterId;
  ItemRow({
    Key key,
    this.items,
    this.bucket,
    this.characterId,
  })  : assert(items != null),
        assert(bucket != null),
        assert(characterId != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool notEmpty = items.isNotEmpty;
    return Container(
      color: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            bucket.name ?? '',
            style: TextStyle(backgroundColor: Colors.red),
          ),
          Container(
            height: 150,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: notEmpty ? items.length : 3,
              itemBuilder: (_, int i) {
                return Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: notEmpty
                      ? ItemCard(
                          item: items[i],
                          characterId: characterId,
                        )
                      : ItemCard.empty(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
