class_name UpgradeData
extends Resource

## Resource that defines an upgrade option.

enum UpgradeType { STAT, WEAPON, ITEM, SPECIAL }

@export var upgrade_name: String = "Upgrade"
@export var description: String = ""
@export var upgrade_type: UpgradeType = UpgradeType.STAT
@export var icon: Texture2D
@export var stat_modifier: StatModifier
@export var weapon_key: String = ""
@export var item_key: String = ""
@export var weight: float = 1.0
