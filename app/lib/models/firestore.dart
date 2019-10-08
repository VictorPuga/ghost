part of models;

class ItemSet extends BaseModel {
  final String userId;
  final String setId;
  final String name;
  final List<Item> weapons;
  final List<Item> armor;
  final List<String> itemIds;
  final DateTime dateCreated;
  final int classCategoryHash;

  ItemSet({
    this.userId,
    this.setId,
    this.name,
    this.weapons,
    this.armor,
    this.itemIds,
    this.dateCreated,
    this.classCategoryHash,
  }) : super([
          userId,
          setId,
          name,
          weapons,
          armor,
          itemIds,
          dateCreated,
          classCategoryHash,
        ]);

  factory ItemSet.fromJson(Map<String, dynamic> res) {
    final DateTime dateCreated = res['dateCreated'] != null
        ? DateTime.tryParse(res['dateCreated'])
        : null;

    final List<Item> weapons = res['weapons'] != null
        ? List.from(
            res['weapons'].map(
              (el) {
                printObject(jsonDecode(el));
                return null;
                return el != null ? Item.fromJson(jsonDecode(el)) : null;
              },
            ),
          )
        : null;
    final armor = [];
    // final List<Item> armor = res['armor'] != null
    //     ? List.from(
    //         res['weapons'].map(
    //           (el) => el != null ? Item.fromJson(jsonDecode(el)) : null,
    //         ),
    //       )
    //     : null;

    final List<String> itemIds = res['itemIds'] != null //
        ? List.from(jsonDecode(res['itemIds']))
        : null;

    return ItemSet(
      userId: res['userId'],
      setId: res['setId'],
      name: res['name'],
      weapons: weapons,
      armor: armor,
      itemIds: itemIds,
      dateCreated: dateCreated,
      classCategoryHash: res['classCategoryHash'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'setId': setId,
        'name': name,
        'weapons': weapons,
        'armor': armor,
        'itemIds': itemIds,
        'dateCreated': dateCreated?.toIso8601String(),
        'classCategoryHash': classCategoryHash,
      };
}
