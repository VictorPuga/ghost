import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/widgets/ui/item_column.dart';

class SelectItems extends StatelessWidget {
  final String name;
  final int type;
  SelectItems({
    Key key,
    this.name,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(name),
        trailing: CupertinoButton(
          child: const Text('Done'),
          padding: const EdgeInsets.all(0),
          onPressed: () =>
              Navigator.of(context).popUntil((Route route) => route.isFirst),
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
              ),
            ),
            Expanded(
              child: ItemColumn(
                itemCount: 5,
                bucketHashes: [
                  DestinyBucketHash.head,
                  DestinyBucketHash.arms,
                  DestinyBucketHash.body,
                  DestinyBucketHash.legs,
                  DestinyBucketHash.classItem,
                ],
                disabled: type == 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
