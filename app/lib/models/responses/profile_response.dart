part of models;

class DestinyProfileResponse extends Destiny2Model {
  final List<String> keys;
  final profile;
  final vendorReceipts;
  final profileInventory;
  final profileCurrencies;
  final profileProgression;
  final Map<String, CharacterComponent> characters;
  final Map<String, List<ItemComponent>> characterInventories;
  final characterProgressions;
  final characterRenderData;
  final characterActivities;
  final Map<String, List<ItemComponent>> characterEquipment;
  final ItemComponentsComponent itemComponents;
  final characterUninstancedItemComponents;
  final profilePlugSets;
  final characterPlugSets;
  final profileKiosks;
  final characterKiosks;
  final characterCurrencyLookups;
  final profilePresentationNodes;
  final characterPresentationNodes;
  final profileCollectibles;
  final characterCollectibles;
  final profileRecords;
  final characterRecords;

  DestinyProfileResponse({
    this.profile,
    this.vendorReceipts,
    this.profileInventory,
    this.profileCurrencies,
    this.profileProgression,
    this.characters,
    this.characterInventories,
    this.characterProgressions,
    this.characterRenderData,
    this.characterActivities,
    this.characterEquipment,
    this.itemComponents,
    this.characterUninstancedItemComponents,
    this.profilePlugSets,
    this.characterPlugSets,
    this.profileKiosks,
    this.characterKiosks,
    this.characterCurrencyLookups,
    this.profilePresentationNodes,
    this.characterPresentationNodes,
    this.profileCollectibles,
    this.characterCollectibles,
    this.profileRecords,
    this.characterRecords,
  })  : keys = _evaluateKeys(
          profile,
          vendorReceipts,
          profileInventory,
          profileCurrencies,
          profileProgression,
          characters,
          characterInventories,
          characterProgressions,
          characterRenderData,
          characterActivities,
          characterEquipment,
          itemComponents,
          characterUninstancedItemComponents,
          profilePlugSets,
          characterPlugSets,
          profileKiosks,
          characterKiosks,
          characterCurrencyLookups,
          profilePresentationNodes,
          characterPresentationNodes,
          profileCollectibles,
          characterCollectibles,
          profileRecords,
          characterRecords,
        ),
        super([
          profile,
          vendorReceipts,
          profileInventory,
          profileCurrencies,
          profileProgression,
          characters,
          characterInventories,
          characterProgressions,
          characterRenderData,
          characterActivities,
          characterEquipment,
          itemComponents,
          characterUninstancedItemComponents,
          profilePlugSets,
          characterPlugSets,
          profileKiosks,
          characterKiosks,
          characterCurrencyLookups,
          profilePresentationNodes,
          characterPresentationNodes,
          profileCollectibles,
          characterCollectibles,
          profileRecords,
          characterRecords,
        ]);

  factory DestinyProfileResponse.fromJson(Map<String, dynamic> res) {
    final profile = res['profile'] != null //
        ? res['profile']
        : null;
    final vendorReceipts = res['vendorReceipts'] != null //
        ? res['vendorReceipts']
        : null;
    final profileInventory = res['profileInventory'] != null //
        ? res['profileInventory']
        : null;
    final profileCurrencies = res['profileCurrencies'] != null //
        ? res['profileCurrencies']
        : null;
    final profileProgression = res['profileProgression'] != null //
        ? res['profileProgression']
        : null;
    final Map<String, CharacterComponent> characters = res['characters'] != null
        ? Map.from(res['characters']['data']).map(
            (k, v) => MapEntry(k, CharacterComponent.fromJson(v)),
          )
        : null;
    final Map<String, List<ItemComponent>> characterInventories =
        res['characterInventories'] != null
            ? Map.from(res['characterInventories']['data']).map(
                (k, v) => MapEntry(
                  k,
                  List.from(
                    res['characterInventories']['data'][k]['items'].map(
                      (_v) => ItemComponent.fromJson(_v),
                    ),
                  ),
                ),
              )
            : null;
    final characterProgressions = res['characterProgressions'] != null
        ? res['characterProgressions']
        : null;
    final characterRenderData = res['characterRenderData'] != null //
        ? res['characterRenderData']
        : null;
    final characterActivities = res['characterActivities'] != null //
        ? res['characterActivities']
        : null;
    final Map<String, List<ItemComponent>> characterEquipment =
        res['characterEquipment'] != null //
            ? Map.from(res['characterEquipment']['data']).map(
                (k, v) => MapEntry(
                  k,
                  List.from(
                    v['items'].map((_v) => ItemComponent.fromJson(_v)),
                  ),
                ),
              )
            : null;

    final ItemComponentsComponent itemComponents =
        res['itemComponents'] != null //
            ? ItemComponentsComponent.fromJson(res['itemComponents'])
            : null;

    final characterUninstancedItemComponents =
        res['characterUninstancedItemComponents'] != null
            ? res['characterUninstancedItemComponents']
            : null;
    final profilePlugSets = res['profilePlugSets'] != null //
        ? res['profilePlugSets']
        : null;
    final characterPlugSets = res['characterPlugSets'] != null //
        ? res['characterPlugSets']
        : null;
    final profileKiosks = res['profileKiosks'] != null //
        ? res['profileKiosks']
        : null;
    final characterKiosks = res['characterKiosks'] != null //
        ? res['characterKiosks']
        : null;
    final characterCurrencyLookups = res['characterCurrencyLookups'] != null
        ? res['characterCurrencyLookups']
        : null;
    final profilePresentationNodes = res['profilePresentationNodes'] != null
        ? res['profilePresentationNodes']
        : null;
    final characterPresentationNodes = res['characterPresentationNodes'] != null
        ? res['characterPresentationNodes']
        : null;
    final profileCollectibles =
        res['profileCollectibles'] != null ? res['profileCollectibles'] : null;
    final characterCollectibles = res['characterCollectibles'] != null
        ? res['characterCollectibles']
        : null;
    final profileRecords = res['profileRecords'] != null //
        ? res['profileRecords']
        : null;
    final characterRecords = res['characterRecords'] != null //
        ? res['characterRecords']
        : null;

    return DestinyProfileResponse(
      profile: profile,
      vendorReceipts: vendorReceipts,
      profileInventory: profileInventory,
      profileCurrencies: profileCurrencies,
      profileProgression: profileProgression,
      characters: characters,
      characterInventories: characterInventories,
      characterProgressions: characterProgressions,
      characterRenderData: characterRenderData,
      characterActivities: characterActivities,
      characterEquipment: characterEquipment,
      itemComponents: itemComponents,
      characterUninstancedItemComponents: characterUninstancedItemComponents,
      profilePlugSets: profilePlugSets,
      characterPlugSets: characterPlugSets,
      profileKiosks: profileKiosks,
      characterKiosks: characterKiosks,
      characterCurrencyLookups: characterCurrencyLookups,
      profilePresentationNodes: profilePresentationNodes,
      characterPresentationNodes: characterPresentationNodes,
      profileCollectibles: profileCollectibles,
      characterCollectibles: characterCollectibles,
      profileRecords: profileRecords,
      characterRecords: characterRecords,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'profile': profile,
        'vendorReceipts': vendorReceipts,
        'profileInventory': profileInventory,
        'profileCurrencies': profileCurrencies,
        'profileProgression': profileProgression,
        'characters': characters,
        'characterInventories': characterInventories,
        'characterProgressions': characterProgressions,
        'characterRenderData': characterRenderData,
        'characterActivities': characterActivities,
        'characterEquipment': characterEquipment,
        'itemComponents': itemComponents,
        'characterUninstancedItemComponents':
            characterUninstancedItemComponents,
        'profilePlugSets': profilePlugSets,
        'characterPlugSets': characterPlugSets,
        'profileKiosks': profileKiosks,
        'characterKiosks': characterKiosks,
        'characterCurrencyLookups': characterCurrencyLookups,
        'profilePresentationNodes': profilePresentationNodes,
        'characterPresentationNodes': characterPresentationNodes,
        'profileCollectibles': profileCollectibles,
        'characterCollectibles': characterCollectibles,
        'profileRecords': profileRecords,
        'characterRecords': characterRecords,
      };

  static List<String> _evaluateKeys(
    profile,
    vendorReceipts,
    profileInventory,
    profileCurrencies,
    profileProgression,
    characters,
    characterInventories,
    characterProgressions,
    characterRenderData,
    characterActivities,
    characterEquipment,
    itemComponents,
    characterUninstancedItemComponents,
    profilePlugSets,
    characterPlugSets,
    profileKiosks,
    characterKiosks,
    characterCurrencyLookups,
    profilePresentationNodes,
    characterPresentationNodes,
    profileCollectibles,
    characterCollectibles,
    profileRecords,
    characterRecords,
  ) {
    final List<String> keys = [
      if (profile != null) 'profile',
      if (vendorReceipts != null) 'vendorReceipts',
      if (profileInventory != null) 'profileInventory',
      if (profileCurrencies != null) 'profileCurrencies',
      if (profileProgression != null) 'profileProgression',
      if (characters != null) 'characters',
      if (characterInventories != null) 'characterInventories',
      if (characterProgressions != null) 'characterProgressions',
      if (characterRenderData != null) 'characterRenderData',
      if (characterActivities != null) 'characterActivities',
      if (characterEquipment != null) 'characterEquipment',
      if (itemComponents != null) 'itemComponents',
      if (characterUninstancedItemComponents != null)
        'characterUninstancedItemComponents',
      if (profilePlugSets != null) 'profilePlugSets',
      if (characterPlugSets != null) 'characterPlugSets',
      if (profileKiosks != null) 'profileKiosks',
      if (characterKiosks != null) 'characterKiosks',
      if (characterCurrencyLookups != null) 'characterCurrencyLookups',
      if (profilePresentationNodes != null) 'profilePresentationNodes',
      if (characterPresentationNodes != null) 'characterPresentationNodes',
      if (profileCollectibles != null) 'profileCollectibles',
      if (characterCollectibles != null) 'characterCollectibles',
      if (profileRecords != null) 'profileRecords',
      if (characterRecords != null) 'characterRecords',
    ];
    return keys;
  }
}
