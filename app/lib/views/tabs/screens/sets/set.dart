import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghost/models/models.dart';
import 'package:ghost/repositories/api_repository.dart';
import 'package:ghost/utils.dart';
import 'package:ghost/widgets/widgets.dart';

class SetView extends StatelessWidget {
  final ItemSet itemSet;
  final String membershipId;
  final int membershipType;
  final String accessToken;
  final List<String> characterIds;

  SetView({
    Key key,
    this.itemSet,
    this.membershipId,
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
                  final result = await APIRepository(accessToken).equipItemSet(
                    items: [
                      ...itemSet.weapons,
                      ...itemSet.armor,
                    ].where((i) => i != null).toList(),
                    characterId: itemSet.characterId,
                    membershipId: membershipId,
                    membershipType: membershipType,
                  );
                  if (result == 1) {
                    showBasicAlert(context, 'Success!', '');
                  }
                  if (result == -1) {
                    showBasicAlert(
                      context,
                      'Error',
                      'Some items are equipped by other characters. Transfer them to the vault or to the desired character first.',
                    );
                  }
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
