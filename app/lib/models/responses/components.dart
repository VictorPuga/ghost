part of models;

class CharacterComponent extends Destiny2Model {
  final String membershipId;
  final int membershipType;
  final String characterId;
  final DateTime dateLastPlayed;
  final minutesPlayedThisSession; // int || string ?
  final minutesPlayedTotal; // int || string ?
  final int light;
  final Map stats;
  final int raceHash;
  final int genderHash;
  final int classHash;
  final int raceType;
  final int genderType;
  final int classType;
  final String emblemPath;
  final String emblemBackgroundPath;
  final int emblemHash;
  final Map emblemColor;
  final Map levelProgression;
  final int baseCharacterLevel;
  final double percentToNextLevel;
  final int titleRecordHash;

  CharacterComponent({
    this.membershipId,
    this.membershipType,
    this.characterId,
    this.dateLastPlayed,
    this.minutesPlayedThisSession,
    this.minutesPlayedTotal,
    this.light,
    this.stats,
    this.raceHash,
    this.genderHash,
    this.classHash,
    this.raceType,
    this.genderType,
    this.classType,
    this.emblemPath,
    this.emblemBackgroundPath,
    this.emblemHash,
    this.emblemColor,
    this.levelProgression,
    this.baseCharacterLevel,
    this.percentToNextLevel,
    this.titleRecordHash,
  }) : super([
          membershipId,
          membershipType,
          characterId,
          dateLastPlayed,
          minutesPlayedThisSession,
          minutesPlayedTotal,
          light,
          stats,
          raceHash,
          genderHash,
          classHash,
          raceType,
          genderType,
          classType,
          emblemPath,
          emblemBackgroundPath,
          emblemHash,
          emblemColor,
          levelProgression,
          baseCharacterLevel,
          percentToNextLevel,
          titleRecordHash,
        ]);

  factory CharacterComponent.fromJson(Map<String, dynamic> res) {
    return CharacterComponent(
      membershipId: res['membershipId'],
      membershipType: res['membershipType'],
      characterId: res['characterId'],
      dateLastPlayed: DateTime.tryParse(res['dateLastPlayed']),
      minutesPlayedThisSession: res['minutesPlayedThisSession'],
      minutesPlayedTotal: res['minutesPlayedTotal'],
      light: res['light'],
      stats: res['stats'],
      raceHash: res['raceHash'],
      genderHash: res['genderHash'],
      classHash: res['classHash'],
      raceType: res['raceType'],
      genderType: res['genderType'],
      classType: res['classType'],
      emblemPath: res['emblemPath'],
      emblemBackgroundPath: res['emblemBackgroundPath'],
      emblemHash: res['emblemHash'],
      emblemColor: res['emblemColor'],
      levelProgression: res['levelProgression'],
      baseCharacterLevel: res['baseCharacterLevel'],
      percentToNextLevel: res['percentToNextLevel'],
      titleRecordHash: res['titleRecordHash'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'membershipId': membershipId,
        'membershipType': membershipType,
        'characterId': characterId,
        'dateLastPlayed': dateLastPlayed.toIso8601String(),
        'minutesPlayedThisSession': minutesPlayedThisSession,
        'minutesPlayedTotal': minutesPlayedTotal,
        'light': light,
        'stats': stats,
        'raceHash': raceHash,
        'genderHash': genderHash,
        'classHash': classHash,
        'raceType': raceType,
        'genderType': genderType,
        'classType': classType,
        'emblemPath': emblemPath,
        'emblemBackgroundPath': emblemBackgroundPath,
        'emblemHash': emblemHash,
        'emblemColor': emblemColor,
        'levelProgression': levelProgression,
        'baseCharacterLevel': baseCharacterLevel,
        'percentToNextLevel': percentToNextLevel,
        'titleRecordHash': titleRecordHash,
      };
}

class ItemComponentsComponent extends Destiny2Model {
  final Map<String, InstanceComponent> instances;
  final perks;
  final renderData;
  final stats;
  final sockets;
  final talentGrids;
  final plugStates;
  final objectives;

  ItemComponentsComponent({
    this.instances,
    this.perks,
    this.renderData,
    this.stats,
    this.sockets,
    this.talentGrids,
    this.plugStates,
    this.objectives,
  }) : super([
          instances,
          perks,
          renderData,
          stats,
          sockets,
          talentGrids,
          plugStates,
          objectives,
        ]);

  factory ItemComponentsComponent.fromJson(Map<String, dynamic> res) {
    final List<MapEntry<String, InstanceComponent>> entries =
        res['instances'] != null
            ? Map<String, dynamic>.from(res['instances']['data'])
                .entries
                .map(
                    (e) => MapEntry(e.key, InstanceComponent.fromJson(e.value)))
                .toList()
            : [];

    final perks = res['perks'] != null //
        ? res['perks']['data']
        : null;
    final renderData = res['renderData'] != null //
        ? res['renderData']['data']
        : null;
    final stats = res['stats'] != null //
        ? res['stats']['data']
        : null;
    final sockets = res['sockets'] != null //
        ? res['sockets']['data']
        : null;
    final talentGrids = res['talentGrids'] != null //
        ? res['talentGrids']['data']
        : null;
    final plugStates = res['plugStates'] != null //
        ? res['plugStates']['data']
        : null;
    final objectives = res['objectives'] != null //
        ? res['objectives']['data']
        : null;

    return ItemComponentsComponent(
      instances: Map.fromEntries(entries),
      perks: perks,
      renderData: renderData,
      stats: stats,
      sockets: sockets,
      talentGrids: talentGrids,
      plugStates: plugStates,
      objectives: objectives,
    );
  }

  // static Map<String, ItemComponentsComponent> multiple(
  //   Map<String, dynamic> res,
  //   List<String> characterIds,
  // ) {
  //   Map<String, ItemComponentsComponent> itemComponents = {};
  //   for (String id in characterIds) {
  //     final List<MapEntry<String, InstanceComponent>> entries =
  //         res['instances'] != null
  //             ? Map<String, dynamic>.from(res['instances']['data'])
  //                 .entries
  //                 .map((e) =>
  //                     MapEntry(e.key, InstanceComponent.fromJson(e.value)))
  //                 .toList()
  //             : [];
  //     // final perks = res['perks'] != null //
  //     //     ? res['perks']['data']
  //     //     : null;
  //     // final renderData = res['renderData'] != null //
  //     //     ? res['renderData']['data']
  //     //     : null;
  //     // final stats = res['stats'] != null //
  //     //     ? res['stats']['data']
  //     //     : null;
  //     // final sockets = res['sockets'] != null //
  //     //     ? res['sockets']['data']
  //     //     : null;
  //     // final talentGrids = res['talentGrids'] != null //
  //     //     ? res['talentGrids']['data']
  //     //     : null;
  //     // final plugStates = res['plugStates'] != null //
  //     //     ? res['plugStates']['data']
  //     //     : null;
  //     // final objectives = res['objectives'] != null //
  //     //     ? res['objectives']['data']
  //     //     : null;

  //     // itemComponents[id] = ItemComponentsComponent(
  //     //   instances: Map.fromEntries(entries),
  //     //   perks: perks,
  //     //   renderData: renderData,
  //     //   stats: stats,
  //     //   sockets: sockets,
  //     //   talentGrids: talentGrids,
  //     //   plugStates: plugStates,
  //     //   objectives: objectives,
  //     // );
  //   }
  //   print(characterIds);
  //   return {};
  // }

  @override
  Map<String, dynamic> toJson() => {
        'instances': instances,
        'perks': perks,
        'renderData': renderData,
        'stats': stats,
        'sockets': sockets,
        'talentGrids': talentGrids,
        'plugStates': plugStates,
        'objectives': objectives,
      };
}

class ItemComponent extends Destiny2Model {
  final int itemHash;
  final String itemInstanceId;
  final int quantity;
  final int bindStatus;
  final int location;
  final int bucketHash;
  final int transferStatus;
  final bool lockable;
  final int state;
  final int overrideStyleItemHash;
  final DateTime expirationDate;

  ItemComponent({
    @required this.itemHash,
    @required this.itemInstanceId,
    @required this.quantity,
    @required this.bindStatus,
    @required this.location,
    @required this.bucketHash,
    @required this.transferStatus,
    @required this.state,
    @required this.lockable,
    @required this.overrideStyleItemHash,
    @required this.expirationDate,
  }) : super([
          itemHash,
          itemInstanceId,
          quantity,
          bindStatus,
          location,
          bucketHash,
          transferStatus,
          state,
          lockable,
          overrideStyleItemHash,
          expirationDate,
        ]);

  factory ItemComponent.fromJson(Map<String, dynamic> res) => ItemComponent(
        itemHash: res['itemHash'],
        itemInstanceId: res['itemInstanceId'],
        quantity: res['quantity'],
        bindStatus: res['bindStatus'],
        location: res['location'],
        bucketHash: res['bucketHash'],
        transferStatus: res['transferStatus'],
        state: res['state'],
        lockable: res['lockable'],
        overrideStyleItemHash: res['overrideStyleItemHash'],
        expirationDate: res['expirationDate'] != null
            ? DateTime.tryParse(res['expirationDate'])
            : null,
      );

  @override
  Map<String, dynamic> toJson() => {
        'itemHash': itemHash,
        'itemInstanceId': itemInstanceId,
        'quantity': quantity,
        'bindStatus': bindStatus,
        'location': location,
        'bucketHash': bucketHash,
        'transferStatus': transferStatus,
        'state': state,
        'lockable': lockable,
        'overrideStyleItemHash': overrideStyleItemHash,
        'expirationDate': expirationDate?.toIso8601String(),
      };
}

class InstanceComponent extends Destiny2Model {
  final int damageType;
  final int damageTypeHash;
  final Map<String, dynamic> primaryStat;
  final int itemLevel;
  final int quality;
  final bool isEquipped;
  final bool canEquip;
  final int equipRequiredLevel;
  final List<int> unlockHashesRequiredToEquip;
  final int cannotEquipReason;

  InstanceComponent({
    this.damageType,
    this.damageTypeHash,
    this.primaryStat,
    this.itemLevel,
    this.quality,
    this.isEquipped,
    this.canEquip,
    this.equipRequiredLevel,
    this.unlockHashesRequiredToEquip,
    this.cannotEquipReason,
  }) : super([
          damageType,
          damageTypeHash,
          primaryStat,
          itemLevel,
          quality,
          isEquipped,
          canEquip,
          equipRequiredLevel,
          unlockHashesRequiredToEquip,
          cannotEquipReason,
        ]);

  factory InstanceComponent.fromJson(Map<String, dynamic> res) =>
      InstanceComponent(
        damageType: res['damageType'],
        damageTypeHash: res['damageTypeHash'],
        primaryStat: res['primaryStat'],
        itemLevel: res['itemLevel'],
        quality: res['quality'],
        isEquipped: res['isEquipped'],
        canEquip: res['canEquip'],
        equipRequiredLevel: res['equipRequiredLevel'],
        unlockHashesRequiredToEquip:
            List<int>.from(res['unlockHashesRequiredToEquip']),
        cannotEquipReason: res['cannotEquipReason'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'damageType': damageType,
        'damageTypeHash': damageTypeHash,
        'primaryStat': primaryStat,
        'itemLevel': itemLevel,
        'quality': quality,
        'isEquipped': isEquipped,
        'canEquip': canEquip,
        'equipRequiredLevel': equipRequiredLevel,
        'unlockHashesRequiredToEquip': unlockHashesRequiredToEquip,
        'cannotEquipReason': cannotEquipReason,
      };
}
