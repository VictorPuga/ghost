part of models;

abstract class DestinyComponentType extends Destiny2Model {
  static const int none = 0;

  /// Returns `profile` for profile.
  ///
  /// Returns nothing for character.
  static const int profiles = 100;

  /// Returns `vendorReceipts` for profile.
  ///
  /// Returns nothing for character.
  static const int vendorReceipts = 101;

  /// Returns `profileInventory` for profile.
  ///
  /// Returns nothing for character.
  static const int profileInventories = 102;

  /// Returns `profileCurrencies` for profile.
  ///
  /// Returns nothing for character.
  static const int profileCurrencies = 103;

  /// Returns `profileProgression` for profile.
  ///
  /// Returns nothing for character.
  static const int profileProgression = 104;

  /// Returns `characters` for profile.
  ///
  /// Returns `character` for character.
  static const int characters = 200;

  /// Returns `characterInventories` for profile.
  ///
  /// Returns `inventory` for character.
  static const int characterInventories = 201;

  /// Returns `characterProgressions` for profile.
  ///
  /// Returns `progressions` for character.
  static const int characterProgressions = 202;

  /// Returns `characterRenderData` for profile.
  ///
  /// Returns `renderData`for character
  static const int characterRenderData = 203;

  /// Returns `characterActivities` for profile.
  ///
  /// Returns `activities` for character.
  static const int characterActivities = 204;

  /// Returns `characterEquipment` for profile.
  ///
  /// Returns `equipment` for character.
  static const int characterEquipment = 205;

  /// Should return `itemComponents` for profile.
  ///
  /// Returns `itemComponents` for character.
  static const int itemInstances = 300;

  /// Returns `characterUninstancedItemComponents` and `itemComponents` for profile.
  ///
  /// Returns `uninstancedItemComponents` and `itemComponents` for character.
  static const int itemObjectives = 301;

  /// Returns `itemComponents` for profile.
  ///
  /// Returns `itemComponents` for character.
  static const int itemPerks = 302;

  /// Returns `itemComponents` for profile.
  ///
  /// Returns `itemComponents` for character.
  static const int itemRenderData = 303;

  /// Returns `itemComponents` for profile.
  ///
  /// Returns `itemComponents` for character.
  static const int itemStats = 304;

  /// Returns `profilePlugSets`, `characterPlugSets`, and `itemComponents` for profile.
  ///
  /// Returns `plugSets` and `itemComponents` for character.
  static const int itemSockets = 305;

  /// Returns `itemComponents` for profile.
  ///
  /// Returns `itemComponents` for character.
  static const int itemTalentGrids = 306;

  /// Seems to not return anything...
  static const int itemCommonData = 307;

  /// Returns `itemComponents` for profile.
  ///
  /// Returns `itemComponents` for character.
  static const int itemPlugStates = 308;

  /// Seems to not return anything...
  static const int vendors = 400;

  /// Seems to not return anything...
  static const int vendorCategories = 401;

  /// Seems to not return anything...
  static const int vendorSales = 402;

  /// Returns `profileKiosks` and `characterKiosks` for profile.
  ///
  /// Returns `kiosks` for character.
  static const int kiosks = 500;

  /// Returns `characterCurrencyLookups` for profile.
  ///
  /// Returns `currencyLookups` for character.
  static const int currencyLookups = 600;

  /// Returns `profilePresentationNodes` and `characterPresentationNodes` for profile.
  ///
  /// Returns `presentationNodes` for character.
  static const int presentationNodes = 700;

  /// Returns `profileCollectibles` and `characterCollectibles` for profile.
  ///
  /// Returns `collectibles` for character.
  static const int collectibles = 800;

  /// Returns `profileRecords` and `characterRecords` for profile.
  ///
  /// Returns `records` for character.
  static const int records = 900;

  @override
  Map<String, int> toJson() => const {
        'profiles': 100,
        'vendorReceipts': 101,
        'profileInventories': 102,
        'profileCurrencies': 103,
        'profileProgression': 104,
        'characters': 200,
        'characterInventories': 201,
        'characterProgressions': 202,
        'characterRenderData': 203,
        'characterActivities': 204,
        'characterEquipment': 205,
        'itemInstances': 300,
        'itemObjectives': 301,
        'itemPerks': 302,
        'itemRenderData': 303,
        'itemStats': 304,
        'itemSockets': 305,
        'itemTalentGrids': 306,
        'itemCommonData': 307,
        'itemPlugStates': 308,
        'vendors': 400,
        'vendorCategories': 401,
        'vendorSales': 402,
        'kiosks': 500,
        'currencyLookups': 600,
        'presentationNodes': 700,
        'collectibles': 800,
        'records': 900,
      };
}

abstract class DestinyItemType extends Destiny2Model {
  static const int none = 0;
  static const int currency = 1;
  static const int armor = 2;
  static const int weapon = 3;
  static const int message = 7;
  static const int engram = 8;
  static const int consumable = 9;
  static const int exchangeMaterial = 10;
  static const int missionReward = 11;
  static const int questStep = 12;
  static const int questStepComplete = 13;
  static const int emblem = 14;
  static const int quest = 15;
  static const int subclass = 16;
  static const int clanBanner = 17;
  static const int aura = 18;
  static const int mod = 19;
  static const int dummy = 20;
  static const int ship = 21;
  static const int vehicle = 22;
  static const int emote = 23;
  static const int ghost = 24;
  static const int package = 25;
  static const int bounty = 26;

  Map<String, int> toJson() => {
        'none': 0,
        'currency': 1,
        'armor': 2,
        'weapon': 3,
        'message': 7,
        'engram': 8,
        'consumable': 9,
        'exchangeMaterial': 10,
        'missionReward': 11,
        'questStep': 12,
        'questStepComplete': 13,
        'emblem': 14,
        'quest': 15,
        'subclass': 16,
        'clanBanner': 17,
        'aura': 18,
        'mod': 19,
        'dummy': 20,
        'ship': 21,
        'vehicle': 22,
        'emote': 23,
        'ghost': 24,
        'package': 25,
        'bounty': 26,
      };
}

abstract class DestinyBucketHash extends Destiny2Model {
  static const int kinetic = 1498876634;
  static const int energy = 2465295065;
  static const int power = 953998645;

  static const int head = 3448274439;
  static const int arms = 3551918588;
  static const int body = 14239492;
  static const int legs = 20886954;
  static const int classItem = 1585787867;
}

// class DestinyProfile extends Destiny2Model {}

class DestinyManifest extends Destiny2Model {
  final String version;
  final String mobileAssetContentPath;
  final List<Map<String, dynamic>> mobileGearAssetDataBases;
  final Map<String, String> mobileWorldContentPaths;
  final Map<String, String> jsonWorldContentPaths;
  final String mobileClanBannerDatabasePath;
  final Map<String, String> mobileGearCDN;
  final List iconImagePyramidInfo;

  DestinyManifest({
    this.version,
    this.mobileAssetContentPath,
    this.mobileGearAssetDataBases,
    this.mobileWorldContentPaths,
    this.jsonWorldContentPaths,
    this.mobileClanBannerDatabasePath,
    this.mobileGearCDN,
    this.iconImagePyramidInfo,
  }) : super([
          version,
          mobileAssetContentPath,
          mobileGearAssetDataBases,
          mobileWorldContentPaths,
          jsonWorldContentPaths,
          mobileClanBannerDatabasePath,
          mobileGearCDN,
          iconImagePyramidInfo,
        ]);

  factory DestinyManifest.fromJson(Map<String, dynamic> res) => DestinyManifest(
        version: res['version'],
        mobileAssetContentPath: res['mobileAssetContentPath'],
        mobileGearAssetDataBases:
            List<Map<String, dynamic>>.from(res['mobileGearAssetDataBases']),
        mobileWorldContentPaths:
            Map<String, String>.from(res['mobileWorldContentPaths']),
        jsonWorldContentPaths:
            Map<String, String>.from(res['jsonWorldContentPaths']),
        mobileClanBannerDatabasePath: res['mobileClanBannerDatabasePath'],
        mobileGearCDN: Map<String, String>.from(res['mobileGearCDN']),
        iconImagePyramidInfo: res['iconImagePyramidInfo'],
      );

  Map<String, dynamic> toJson() => {
        'version': version,
        'mobileAssetContentPath': mobileAssetContentPath,
        'mobileGearAssetDataBases': mobileGearAssetDataBases,
        'mobileWorldContentPaths': mobileWorldContentPaths,
        'jsonWorldContentPaths': jsonWorldContentPaths,
        'mobileClanBannerDatabasePath': mobileClanBannerDatabasePath,
        'mobileGearCDN': mobileGearCDN,
        'iconImagePyramidInfo': iconImagePyramidInfo,
      };
}

class Item extends Destiny2Model {
  final String name;
  final int itemHash;
  final String itemInstanceId;
  final int bucketHash;
  final String icon;
  final int primaryStat;
  final String description;
  final int typeHash;
  final int subTypeHash;

  bool isEquiped;
  final bool hasPrimaryStat;

  final damageType;

  Item({
    this.name,
    this.itemHash,
    this.itemInstanceId,
    this.bucketHash,
    this.icon,
    this.primaryStat,
    this.description,
    this.typeHash,
    this.subTypeHash,
    this.isEquiped,
    this.damageType,
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
          subTypeHash,
          isEquiped,
          damageType,
        ]);

  factory Item.fromResponse(
    ItemComponent item,
    ItemDefinition definition,
    InstanceComponent instance,
  ) {
    final int damage = null; //instance.damageType;
    final String name = definition.displayProperties.name;
    final String icon = name != 'Classified'
        ? definition.displayProperties.icon
        : 'http://www.odgw.com/forums/uploads/gallery/album_25/gallery_3209_25_129107.png';
    final primaryStat = (instance.primaryStat ?? {})['value'];
    return Item(
      name: name,
      itemHash: item.itemHash,
      itemInstanceId: item.itemInstanceId,
      bucketHash: item.bucketHash,
      icon: icon,
      primaryStat: primaryStat,
      description: definition.displayProperties.description,
      typeHash: definition.itemType,
      subTypeHash: definition.itemSubType,
      isEquiped: instance.isEquipped,
      damageType: damage,
    );
  }

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
        'subTypeHash': subTypeHash,
        'isEquiped': isEquiped,
        'damageType': damageType,
        'hasPrimaryStat': hasPrimaryStat,
      };

  void equip() => isEquiped = true;
  void unEquip() => isEquiped = false;
}

class Character extends Destiny2Model {
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
    CharacterComponent character,
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
        character.emblemColor['alpha'],
        character.emblemColor['red'],
        character.emblemColor['green'],
        character.emblemColor['blue'],
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

class CharacterData extends Destiny2Model {
  final String className;
  final String raceName;

  CharacterData({this.className, this.raceName}) : super([className, raceName]);

  @override
  Map<String, String> toJson() => {
        'className': className,
        'raceName': raceName,
      };
}

class Bucket extends Destiny2Model {
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
    final properties =
        DisplayProperties.fromJson(res['displayProperties'] ?? {});
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

class SortedItems<T> extends Destiny2Model {
  Map<int, T> categories;
  Map<int, List<Item>> items;

  SortedItems({
    @required this.categories,
    @required this.items,
  }) : super([categories, items]) {}

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

class SortedFraction<T> extends Destiny2Model {
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
