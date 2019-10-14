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
  final String characterId;

  ItemSet({
    this.userId,
    this.setId,
    this.name,
    this.weapons,
    this.armor,
    this.itemIds,
    this.dateCreated,
    this.classCategoryHash,
    this.characterId,
  }) : super([
          userId,
          setId,
          name,
          weapons,
          armor,
          itemIds,
          dateCreated,
          classCategoryHash,
          characterId,
        ]);

  factory ItemSet.fromJson(Map<String, dynamic> res) {
    final DateTime dateCreated = res['dateCreated'] != null
        ? DateTime.tryParse(res['dateCreated'])
        : null;

    final List<Item> weapons = res['weapons'] != null
        ? List.from(
            res['weapons'].map(
              (el) => el != null
                  ? Item.fromJson(Map<String, dynamic>.from(el))
                  : null,
            ),
          )
        : null;

    final List<Item> armor = res['armor'] != null
        ? List.from(
            res['armor'].map(
              (el) => el != null
                  ? Item.fromJson(Map<String, dynamic>.from(el))
                  : null,
            ),
          )
        : null;

    final List<String> itemIds = res['itemIds'] != null //
        ? List.from(res['itemIds'])
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
      characterId: res['characterId'],
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
        'characterId': characterId
      };
}
