part of models;

abstract class DestinyBucketHash extends BaseModel {
  static const int kinetic = 1498876634;
  static const int energy = 2465295065;
  static const int power = 953998645;

  static const int head = 3448274439;
  static const int arms = 3551918588;
  static const int body = 14239492;
  static const int legs = 20886954;
  static const int classItem = 1585787867;

  static const int general = 138197802;
}

abstract class DestinyStatHash extends BaseModel {
  static const int defense = 3897883278;
  static const int attack = 1480404414;
}

abstract class DestinyCategoryHash extends BaseModel {
  static const int warlock = 21;
  static const int titan = 22;
  static const int hunter = 23;
}

class Item extends BaseModel {
  final String name;
  final int itemHash;
  final String itemInstanceId;
  final int bucketHash;
  final String icon;
  final int primaryStat;
  final String description;
  final int typeHash;
  final String typeName;
  final int subTypeHash;
  bool isEquiped;
  final bool hasPrimaryStat;

  final damageType;
  final itemCategoryHashes;

  final int classRequired;

  Item({
    this.name,
    this.itemHash,
    this.itemInstanceId,
    this.bucketHash,
    this.icon,
    this.primaryStat,
    this.description,
    this.typeHash,
    this.typeName,
    this.subTypeHash,
    this.isEquiped,
    this.damageType,
    this.itemCategoryHashes,
    this.classRequired,
  })  : hasPrimaryStat = primaryStat != null,
        super([
          name,
          itemHash,
          itemInstanceId,
          bucketHash,
          icon,
          primaryStat,
          description,
          typeHash,
          typeName,
          subTypeHash,
          isEquiped,
          damageType,
          itemCategoryHashes,
          classRequired,
        ]);

  factory Item.fromResponse(
    DestinyItemComponent item,
    DestinyInventoryItemDefinition definition,
    DestinyItemInstanceComponent instance,
  ) {
    final int damage = null; //instance.damageType;
    final String name = definition.displayProperties.name;
    final String icon = (name == 'Classified' ||
            definition.displayProperties.icon == null)
        ? 'http://www.odgw.com/forums/uploads/gallery/album_25/gallery_3209_25_129107.png'
        : _assetPrefix + definition.displayProperties.icon;
    final primaryStat = instance.primaryStat?.value;
    int classRequired;
    if (definition.itemCategoryHashes.contains(DestinyCategoryHash.warlock)) {
      classRequired = DestinyCategoryHash.warlock;
    } else if (definition.itemCategoryHashes
        .contains(DestinyCategoryHash.titan)) {
      classRequired = DestinyCategoryHash.titan;
    } else if (definition.itemCategoryHashes
        .contains(DestinyCategoryHash.hunter)) {
      classRequired = DestinyCategoryHash.hunter;
    }
    return Item(
      name: name,
      itemHash: item.itemHash,
      itemInstanceId: item.itemInstanceId,
      bucketHash: item.bucketHash,
      icon: icon,
      primaryStat: primaryStat,
      description: definition.displayProperties.description,
      typeHash: definition.itemType,
      typeName: definition.itemTypeDisplayName,
      subTypeHash: definition.itemSubType,
      isEquiped: instance.isEquipped,
      damageType: damage,
      itemCategoryHashes: definition.itemCategoryHashes,
      classRequired: classRequired,
    );
  }

  factory Item.fromJson(Map<String, dynamic> res) => Item(
        name: res['name'],
        itemHash: res['itemHash'],
        itemInstanceId: res['itemInstanceId'],
        bucketHash: res['bucketHash'],
        icon: res['icon'],
        primaryStat: res['primaryStat'],
        description: res['description'],
        typeHash: res['typeHash'],
        typeName: res['typeName'],
        subTypeHash: res['subTypeHash'],
        isEquiped: res['isEquiped'],
        damageType: res['damageType'],
        itemCategoryHashes: res['itemCategoryHashes'],
        classRequired: res['classRequired'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'itemHash': itemHash,
        'itemInstanceId': itemInstanceId,
        'bucketHash': bucketHash,
        'icon': icon,
        'primaryStat': primaryStat,
        'description': description,
        'typeHash': typeHash,
        'typeName': typeName,
        'subTypeHash': subTypeHash,
        'isEquiped': isEquiped,
        'damageType': damageType,
        'itemCategoryHashes': itemCategoryHashes,
        'classRequired': classRequired,
        'hasPrimaryStat': hasPrimaryStat,
      };

  void equip() => isEquiped = true;
  void unEquip() => isEquiped = false;
}

class Character extends BaseModel {
  final String characterId;
  final String className;
  final String raceName;
  final String genderName;
  final int light;
  final String emblemPath;
  final String emblemBackgroundPath;
  final Color emblemColor;
  final int level;
  final int titleRecordHash;

  Character({
    this.characterId,
    this.className,
    this.raceName,
    this.genderName,
    this.light,
    this.emblemPath,
    this.emblemBackgroundPath,
    this.emblemColor,
    this.level,
    this.titleRecordHash,
  }) : super([
          characterId,
          className,
          raceName,
          genderName,
          light,
          emblemPath,
          emblemBackgroundPath,
          emblemColor,
          level,
          titleRecordHash,
        ]);

  factory Character.fromResponse(
    DestinyCharacterComponent character,
    CharacterData data,
  ) {
    return Character(
      characterId: character.characterId,
      className: data.className,
      raceName: data.raceName,
      genderName: null,
      light: character.light,
      emblemPath: _assetPrefix + character.emblemPath,
      emblemBackgroundPath: _assetPrefix + character.emblemBackgroundPath,
      emblemColor: Color.fromARGB(
        character.emblemColor.alpha,
        character.emblemColor.red,
        character.emblemColor.green,
        character.emblemColor.blue,
      ),
      titleRecordHash: character.titleRecordHash,
    );
  }
  @override
  Map<String, dynamic> toJson() => {
        'characterId': characterId,
        'className': className,
        'raceName': raceName,
        'genderName': genderName,
        'light': light,
        'emblemPath': emblemPath,
        'emblemBackgroundPath': emblemBackgroundPath,
        'emblemColor': emblemColor.toString(),
        'level': level,
        'titleRecordHash': titleRecordHash,
      };
}

class CharacterData extends BaseModel {
  final String className;
  final String raceName;

  CharacterData({this.className, this.raceName}) : super([className, raceName]);

  @override
  Map<String, String> toJson() => {
        'className': className,
        'raceName': raceName,
      };
}

class Bucket extends BaseModel {
  String name;
  String description;
  int hash;
  bool hasIcon;
  String icon;

  Bucket({
    this.name,
    this.description,
    this.hash,
    this.hasIcon,
    this.icon,
  }) : super([name, description, hash, hasIcon, icon]);

  factory Bucket.fromJson(Map<String, dynamic> res) {
    final properties = DestinyDisplayPropertiesDefinition.fromJson(
        res['displayProperties'] ?? {});
    return Bucket(
      name: properties.name,
      description: properties.description,
      hash: res['hash'],
      hasIcon: properties.hasIcon,
      icon: properties.icon,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'hash': hash,
        'hasIcon': hasIcon,
        'icon': icon,
      };
}

class SortedItems<T> extends BaseModel {
  Map<int, T> categories;
  Map<int, List<Item>> items;

  SortedItems({
    @required this.categories,
    @required this.items,
  }) : super([categories, items]);

  @override
  Map<String, dynamic> toJson() => {
        'categories': categories,
        'items': items,
      };

  void addTo(int key, List<Item> newItems, {T newCategory}) {
    if (categories.containsKey(key)) {
      if (newCategory == null) {
        items.addAll({key: newItems});
      } else {
        throw Exception("Don't provide a `newCategory` if it already exists");
      }
    } else if (newCategory != null) {
      categories.addAll({key: newCategory});
      items.addAll({key: newItems});
    } else {
      throw Exception(
        'The `key` does not exist. Provide a `newCategory` to add those `items`',
      );
    }
  }

  /// Returns a new `SortedItems` instance with the categories casted to the indicated type.
  ///
  /// Throws `Exception` if any item fails the cast
  SortedItems<N> cast<N>() {
    if (categories is Map<int, T>) {
      return SortedItems<N>(
        categories: categories as Map<int, N>,
        items: items,
      );
    }
    throw Exception('Type `$T` is not a subtype of `$N`');
  }

  /// Returns a `Map` with the corresponding category and items.
  SortedFraction<T> operator [](int i) {
    if (categories != null &&
        items != null &&
        categories[i] != null &&
        items[i] != null) {
      return SortedFraction(
        category: categories[i],
        items: items[i],
      );
    }
    return null;
  }
}

class SortedFraction<T> extends BaseModel {
  final T category;
  final List<Item> items;

  SortedFraction({
    @required this.category,
    @required this.items,
  }) : super([category, items]);

  @override
  Map<String, dynamic> toJson() => {
        'category': category,
        'items': items,
      };
}
