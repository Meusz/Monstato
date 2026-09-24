extends Node

## UpgradeSystem - Manages upgrade generation and selection.
## Generates 3 random upgrades for the player to choose from.

var _available_upgrades: Array[UpgradeData] = []
var _current_options: Array[UpgradeData] = []

func _ready() -> void:
	EventBus.level_up.connect(_on_level_up)
	_register_upgrades()

func _register_upgrades() -> void:
	_add_stat_upgrade("Damage Up", "+15% Damage", StatModifier.Stat.DAMAGE, 0.15, StatModifier.ModifierType.PERCENTAGE)
	_add_stat_upgrade("Speed Up", "+15 Speed", StatModifier.Stat.SPEED, 15.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Health Up", "+25 Max Health", StatModifier.Stat.MAX_HEALTH, 25.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Armor Up", "+5 Armor", StatModifier.Stat.ARMOR, 5.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Crit Up", "+5% Crit Chance", StatModifier.Stat.CRIT_CHANCE, 0.05, StatModifier.ModifierType.PERCENTAGE)
	_add_stat_upgrade("Regen Up", "+0.5 Regen", StatModifier.Stat.REGENERATION, 0.5, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Attack Speed Up", "+10% Attack Speed", StatModifier.Stat.ATTACK_SPEED, 0.10, StatModifier.ModifierType.PERCENTAGE)
	_add_stat_upgrade("Range Up", "+15% Range", StatModifier.Stat.RANGE, 0.15, StatModifier.ModifierType.PERCENTAGE)
	_add_stat_upgrade("Pickup Range Up", "+25 Pickup Range", StatModifier.Stat.PICKUP_RANGE, 25.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Knockback Up", "+25 Knockback", StatModifier.Stat.KNOCKBACK_FORCE, 25.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Life Steal Up", "+5% Life Steal", StatModifier.Stat.LIFE_STEAL, 0.05, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Dodge Up", "+5% Dodge", StatModifier.Stat.DODGE, 0.05, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Melee Damage Up", "+5 Melee Damage", StatModifier.Stat.MELEE_DAMAGE, 5.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Ranged Damage Up", "+5 Ranged Damage", StatModifier.Stat.RANGED_DAMAGE, 5.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Engineering Up", "+5 Engineering", StatModifier.Stat.ENGINEERING, 5.0, StatModifier.ModifierType.FLAT)
	_add_stat_upgrade("Harvesting Up", "+3 Harvesting", StatModifier.Stat.HARVESTING, 3.0, StatModifier.ModifierType.FLAT)

func _add_stat_upgrade(name: String, desc: String, stat: StatModifier.Stat, value: float, mod_type: StatModifier.ModifierType) -> void:
	var upgrade := UpgradeData.new()
	upgrade.upgrade_name = name
	upgrade.description = desc
	upgrade.upgrade_type = UpgradeData.UpgradeType.STAT
	upgrade.stat_modifier = StatModifier.new()
	upgrade.stat_modifier.stat = stat
	upgrade.stat_modifier.value = value
	upgrade.stat_modifier.modifier_type = mod_type
	_available_upgrades.append(upgrade)

func _on_level_up(_new_level: int) -> void:
	offer_upgrades()

func offer_upgrades() -> void:
	_current_options = _generate_options(3)
	EventBus.upgrade_offered.emit(_current_options)

func _generate_options(count: int) -> Array[UpgradeData]:
	var shuffled := _available_upgrades.duplicate()
	shuffled.shuffle()
	return shuffled.slice(0, mini(count, shuffled.size()))

func select_upgrade(index: int) -> void:
	if index < 0 or index >= _current_options.size():
		return
	var upgrade := _current_options[index]
	_apply_upgrade(upgrade)
	EventBus.upgrade_selected.emit(upgrade)
	_current_options.clear()
	EventBus.upgrade_completed.emit()

func _apply_upgrade(upgrade: UpgradeData) -> void:
	match upgrade.upgrade_type:
		UpgradeData.UpgradeType.STAT:
			if upgrade.stat_modifier:
				var key := upgrade.stat_modifier._stat_to_key(upgrade.stat_modifier.stat)
				if upgrade.stat_modifier.modifier_type == StatModifier.ModifierType.PERCENTAGE:
					var current := DataBus.get_stat(key)
					DataBus.set_stat(key, current * (1.0 + upgrade.stat_modifier.value))
				else:
					DataBus.modify_stat(key, upgrade.stat_modifier.value)
		UpgradeData.UpgradeType.WEAPON:
			pass
		UpgradeData.UpgradeType.ITEM:
			pass
		UpgradeData.UpgradeType.SPECIAL:
			pass

func get_current_options() -> Array[UpgradeData]:
	return _current_options
