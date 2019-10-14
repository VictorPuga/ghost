import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/widgets/widgets.dart';

class SetView extends StatelessWidget {
  final ItemSet itemSet;
  final int membershipType;
  final String accessToken;
  final List<String> characterIds;

  SetView({
    Key key,
    this.itemSet,
    this.membershipType,
    this.accessToken,
    this.characterIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(itemSet.name),
      ),
      child: ListView(
        children: [
          for (Item i in [...itemSet.weapons, ...itemSet.armor])
            i != null
                ? Container(
                    height: 100,
                    width: 100,
                    child: ItemCard(
                      item: i,
                    ),
                  )
                : Container(),
          Container(
            child: CupertinoButton.filled(
              onPressed: () async {
                if (itemSet.classCategoryHash != null) {
                  await APIRepository().equipItemSet(
                    ids: itemSet.itemIds,
                    characterId: itemSet.characterId,
                    membershipType: membershipType,
                    accessToken: accessToken,
                  );
                } else {}
              },
              child: const Text('equip'),
            ),
          ),
        ],
      ),
    );
  }
}
