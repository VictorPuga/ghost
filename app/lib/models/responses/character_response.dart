part of models;

class DestinyCharacterResponse extends Destiny2Model {
  final List<String> keys;
  final List<ItemComponent> inventory;
  final CharacterComponent character;
  final progressons;
  final renderData;
  final activities;
  final List<ItemComponent> equipment;
  final kiosks;
  final plugSets;
  final presentationNodes;
  final records;
  final collectibles;
  final ItemComponentsComponent itemComponents;
  final uninstancedItemComponents;
  final currencyLookups;

  DestinyCharacterResponse({
    this.inventory,
    this.character,
    this.progressons,
    this.renderData,
    this.activities,
    this.equipment,
    this.kiosks,
    this.plugSets,
    this.presentationNodes,
    this.records,
    this.collectibles,
    this.itemComponents,
    this.uninstancedItemComponents,
    this.currencyLookups,
  })  : keys = _evaluateKeys(
          inventory,
          character,
          progressons,
          renderData,
          activities,
          equipment,
          kiosks,
          plugSets,
          presentationNodes,
          records,
          collectibles,
          itemComponents,
          uninstancedItemComponents,
          currencyLookups,
        ),
        super([
          inventory,
          character,
          progressons,
          renderData,
          activities,
          equipment,
          kiosks,
          plugSets,
          presentationNodes,
          records,
          collectibles,
          itemComponents,
          uninstancedItemComponents,
          currencyLookups,
        ]);

  factory DestinyCharacterResponse.fromJson(Map<String, dynamic> res) {
    final List<ItemComponent> inventory = res['inventory'] != null
        ? List.from(res['inventory']['data']['items'])
            .map((el) => ItemComponent.fromJson(el))
            .toList()
        : null;
    final CharacterComponent character = res['character'] != null //
        ? CharacterComponent.fromJson(res['character']['data'])
        : null;
    final progressons = res['progressons'] != null //
        ? res['progressons']
        : null;
    final renderData = res['renderData'] != null //
        ? res['renderData']
        : null;
    final activities = res['activities'] != null //
        ? res['activities']
        : null;
    final List<ItemComponent> equipment = res['equipment'] != null
        ? List.from(res['equipment']['data']['items'])
            .map((el) => ItemComponent.fromJson(el))
            .toList()
        : null;
    final kiosks = res['kiosks'] != null //
        ? res['kiosks']
        : null;
    final plugSets = res['plugSets'] != null //
        ? res['plugSets']
        : null;
    final presentationNodes = res['presentationNodes'] != null //
        ? res['presentationNodes']
        : null;
    final records = res['records'] != null //
        ? res['records']
        : null;
    final collectibles = res['collectibles'] != null //
        ? res['collectibles']
        : null;
    final itemComponents = res['itemComponents'] != null //
        ? ItemComponentsComponent.fromJson(res['itemComponents'])
        : null;
    final uninstancedItemComponents = res['uninstancedItemComponents'] != null
        ? res['uninstancedItemComponents']
        : null;
    final currencyLookups = res['currencyLookups'] != null //
        ? res['currencyLookups']
        : null;

    return DestinyCharacterResponse(
      inventory: inventory,
      character: character,
      progressons: progressons,
      renderData: renderData,
      activities: activities,
      equipment: equipment,
      kiosks: kiosks,
      plugSets: plugSets,
      presentationNodes: presentationNodes,
      records: records,
      collectibles: collectibles,
      itemComponents: itemComponents,
      uninstancedItemComponents: uninstancedItemComponents,
      currencyLookups: currencyLookups,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'inventory': inventory,
        'character': character,
        'progressons': progressons,
        'renderData': renderData,
        'activities': activities,
        'equipment': equipment,
        'kiosks': kiosks,
        'plugSets': plugSets,
        'presentationNodes': presentationNodes,
        'records': records,
        'collectibles': collectibles,
        'itemComponents': itemComponents,
        'uninstancedItemComponents': uninstancedItemComponents,
        'currencyLookups': currencyLookups,
      };

  static List<String> _evaluateKeys(
    inventory,
    character,
    progressons,
    renderData,
    activities,
    equipment,
    kiosks,
    plugSets,
    presentationNodes,
    records,
    collectibles,
    itemComponents,
    uninstancedItemComponents,
    currencyLookups,
  ) {
    final List<String> keys = [
      if (inventory != null) 'inventory',
      if (character != null) 'character',
      if (progressons != null) 'progressons',
      if (renderData != null) 'renderData',
      if (activities != null) 'activities',
      if (equipment != null) 'equipment',
      if (kiosks != null) 'kiosks',
      if (plugSets != null) 'plugSets',
      if (presentationNodes != null) 'presentationNodes',
      if (records != null) 'records',
      if (collectibles != null) 'collectibles',
      if (itemComponents != null) 'itemComponents',
      if (uninstancedItemComponents != null) 'uninstancedItemComponents',
      if (currencyLookups != null) 'currencyLookups',
    ];
    return keys;
  }
}
