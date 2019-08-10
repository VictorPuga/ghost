part of models;

class DisplayProperties extends Destiny2Model {
  final String description;
  final String name;
  final String icon;
  final bool hasIcon;

  DisplayProperties({
    this.description,
    this.name,
    this.icon,
    this.hasIcon,
  }) : super([description, name, icon, hasIcon]);

  factory DisplayProperties.fromJson(Map<String, dynamic> res) {
    final String icon = res['hasIcon'] ? _assetPrefix + res['icon'] : null;
    return DisplayProperties(
      description: res['description'],
      name: res['name'],
      icon: icon,
      hasIcon: res['hasIcon'],
    );
  }
  @override
  Map<String, dynamic> toJson() => {
        'description': description,
        'name': name,
        'icon': icon,
        'hasIcon': hasIcon,
      };
}

class ItemDefinition extends Destiny2Model {
  final DisplayProperties displayProperties;
  final int collectibleHash; // nullable
  final String secondaryIcon;
  final String secondaryOverlay;
  final String secondarySpecial;
  final Map backgroundColor;
  final String screenshot;
  final String itemTypeDisplayName;
  final String uiItemDisplayStyle;
  final String itemTypeAndTierDisplayName;
  final String displaySource;
  final String tooltipStyle;
  final Map action;
  final Map inventory;
  final Map setData;
  final Map stats;
  final int emblemObjectiveHash; // nullable
  final Map equippingBlock;
  final Map translationBlock;
  final Map preview;
  final Map quality;
  final Map value;
  final Map sourceData;
  final Map objectives;
  final Map plug;
  final Map gearset;
  final Map sack;
  final Map sockets;
  final Map summary;
  final Map talentGrid;
  final List investmentStats;
  final List perks;
  final int loreHash; // nullable
  final int summaryItemHash;
  final List animations;
  final bool allowActions;
  final List links;
  final bool doesPostmasterPullHaveSideEffects;
  final bool nonTransferrable;
  final List itemCategoryHashes;
  final int specialItemType;
  final int itemType;
  final int itemSubType;
  final int classType;
  final bool equippable;
  final List damageTypeHashes;
  final List damageTypes;
  final int defaultDamageType;
  final int defaultDamageTypeHash; // nullable
  final int hash;
  final int index;
  final bool redacted;

  ItemDefinition({
    this.displayProperties,
    this.collectibleHash,
    this.secondaryIcon,
    this.secondaryOverlay,
    this.secondarySpecial,
    this.backgroundColor,
    this.screenshot,
    this.itemTypeDisplayName,
    this.uiItemDisplayStyle,
    this.itemTypeAndTierDisplayName,
    this.displaySource,
    this.tooltipStyle,
    this.action,
    this.inventory,
    this.setData,
    this.stats,
    this.emblemObjectiveHash,
    this.equippingBlock,
    this.translationBlock,
    this.preview,
    this.quality,
    this.value,
    this.sourceData,
    this.objectives,
    this.plug,
    this.gearset,
    this.sack,
    this.sockets,
    this.summary,
    this.talentGrid,
    this.investmentStats,
    this.perks,
    this.loreHash,
    this.summaryItemHash,
    this.animations,
    this.allowActions,
    this.links,
    this.doesPostmasterPullHaveSideEffects,
    this.nonTransferrable,
    this.itemCategoryHashes,
    this.specialItemType,
    this.itemType,
    this.itemSubType,
    this.classType,
    this.equippable,
    this.damageTypeHashes,
    this.damageTypes,
    this.defaultDamageType,
    this.defaultDamageTypeHash,
    this.hash,
    this.index,
    this.redacted,
  }) : super([
          displayProperties,
          collectibleHash,
          secondaryIcon,
          secondaryOverlay,
          secondarySpecial,
          backgroundColor,
          screenshot,
          itemTypeDisplayName,
          uiItemDisplayStyle,
          itemTypeAndTierDisplayName,
          displaySource,
          tooltipStyle,
          action,
          inventory,
          setData,
          stats,
          emblemObjectiveHash,
          equippingBlock,
          translationBlock,
          preview,
          quality,
          value,
          sourceData,
          objectives,
          plug,
          gearset,
          sack,
          sockets,
          summary,
          talentGrid,
          investmentStats,
          perks,
          loreHash,
          summaryItemHash,
          animations,
          allowActions,
          links,
          doesPostmasterPullHaveSideEffects,
          nonTransferrable,
          itemCategoryHashes,
          specialItemType,
          itemType,
          itemSubType,
          classType,
          equippable,
          damageTypeHashes,
          damageTypes,
          defaultDamageType,
          defaultDamageTypeHash,
          hash,
          index,
          redacted,
        ]);

  factory ItemDefinition.fromJson(
    Map<String, dynamic> res,
  ) {
    final displayProperties = res['displayProperties'] != null
        ? DisplayProperties.fromJson(res['displayProperties'])
        : null;
    final screenshot =
        res['screenshot'] != null ? _assetPrefix + res['screenshot'] : null;

    return ItemDefinition(
      displayProperties: displayProperties,
      collectibleHash: res['collectibleHash'],
      secondaryIcon: res['secondaryIcon'],
      secondaryOverlay: res['secondaryOverlay'],
      secondarySpecial: res['secondarySpecial'],
      backgroundColor: res['backgroundColor'],
      screenshot: screenshot,
      itemTypeDisplayName: res['itemTypeDisplayName'],
      uiItemDisplayStyle: res['uiItemDisplayStyle'],
      itemTypeAndTierDisplayName: res['itemTypeAndTierDisplayName'],
      displaySource: res['displaySource'],
      tooltipStyle: res['tooltipStyle'],
      action: res['action'],
      inventory: res['inventory'],
      setData: res['setData'],
      stats: res['stats'],
      emblemObjectiveHash: res['emblemObjectiveHash'],
      equippingBlock: res['equippingBlock'],
      translationBlock: res['translationBlock'],
      preview: res['preview'],
      quality: res['quality'],
      value: res['value'],
      sourceData: res['sourceData'],
      objectives: res['objectives'],
      plug: res['plug'],
      gearset: res['gearset'],
      sack: res['sack'],
      sockets: res['sockets'],
      summary: res['summary'],
      talentGrid: res['talentGrid'],
      investmentStats: res['investmentStats'],
      perks: res['perks'],
      loreHash: res['loreHash'],
      summaryItemHash: res['summaryItemHash'],
      animations: res['animations'],
      allowActions: res['allowActions'],
      links: res['links'],
      doesPostmasterPullHaveSideEffects:
          res['doesPostmasterPullHaveSideEffects'],
      nonTransferrable: res['nonTransferrable'],
      itemCategoryHashes: res['itemCategoryHashes'],
      specialItemType: res['specialItemType'],
      itemType: res['itemType'],
      itemSubType: res['itemSubType'],
      classType: res['classType'],
      equippable: res['equippable'],
      damageTypeHashes: res['damageTypeHashes'],
      damageTypes: res['damageTypes'],
      defaultDamageType: res['defaultDamageType'],
      defaultDamageTypeHash: res['defaultDamageTypeHash'],
      hash: res['hash'],
      index: res['index'],
      redacted: res['redacted'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'displayProperties': displayProperties,
        'collectibleHash': collectibleHash,
        'secondaryIcon': secondaryIcon,
        'secondaryOverlay': secondaryOverlay,
        'secondarySpecial': secondarySpecial,
        'backgroundColor': backgroundColor,
        'screenshot': screenshot,
        'itemTypeDisplayName': itemTypeDisplayName,
        'uiItemDisplayStyle': uiItemDisplayStyle,
        'itemTypeAndTierDisplayName': itemTypeAndTierDisplayName,
        'displaySource': displaySource,
        'tooltipStyle': tooltipStyle,
        'action': action,
        'inventory': inventory,
        'setData': setData,
        'stats': stats,
        'emblemObjectiveHash': emblemObjectiveHash,
        'equippingBlock': equippingBlock,
        'translationBlock': translationBlock,
        'preview': preview,
        'quality': quality,
        'value': value,
        'sourceData': sourceData,
        'objectives': objectives,
        'plug': plug,
        'gearset': gearset,
        'sack': sack,
        'sockets': sockets,
        'summary': summary,
        'talentGrid': talentGrid,
        'investmentStats': investmentStats,
        'perks': perks,
        'loreHash': loreHash,
        'summaryItemHash': summaryItemHash,
        'animations': animations,
        'allowActions': allowActions,
        'links': links,
        'doesPostmasterPullHaveSideEffects': doesPostmasterPullHaveSideEffects,
        'nonTransferrable': nonTransferrable,
        'itemCategoryHashes': itemCategoryHashes,
        'specialItemType': specialItemType,
        'itemType': itemType,
        'itemSubType': itemSubType,
        'classType': classType,
        'equippable': equippable,
        'damageTypeHashes': damageTypeHashes,
        'damageTypes': damageTypes,
        'defaultDamageType': defaultDamageType,
        'defaultDamageTypeHash': defaultDamageTypeHash,
        'hash': hash,
        'index': index,
        'redacted': redacted,
      };
}
