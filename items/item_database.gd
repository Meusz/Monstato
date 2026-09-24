extends Node

## ItemDatabase - Central database for all items.

var _items: Dictionary = {}

func _ready() -> void:
	_register_defaults()

func _register_defaults() -> void:
	# Passives
	_add("power_glove", _passive("Power Glove", "+15% Damage", 25, Rarity.Tier.COMMON, [
		_mod(StatModifier.Stat.DAMAGE, 0.15, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("leather_boots", _passive("Leather Boots", "+10 Speed", 20, Rarity.Tier.COMMON, [
		_mod(StatModifier.Stat.SPEED, 10.0, StatModifier.ModifierType.FLAT),
	]))
	_add("iron_armor", _passive("Iron Armor", "+5 Armor", 30, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.ARMOR, 5.0, StatModifier.ModifierType.FLAT),
	]))
	_add("lucky_charm", _passive("Lucky Charm", "+10% Crit Chance", 40, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.CRIT_CHANCE, 0.10, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("vitality_ring", _passive("Vitality Ring", "+25 Max Health", 35, Rarity.Tier.COMMON, [
		_mod(StatModifier.Stat.MAX_HEALTH, 25.0, StatModifier.ModifierType.FLAT),
	]))
	_add("swift_gloves", _passive("Swift Gloves", "+20% Attack Speed", 45, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.ATTACK_SPEED, 0.20, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("berserker_ring", _passive("Berserker Ring", "+30% Damage, -10 Max Health", 50, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.DAMAGE, 0.30, StatModifier.ModifierType.PERCENTAGE),
		_mod(StatModifier.Stat.MAX_HEALTH, -10.0, StatModifier.ModifierType.FLAT),
	]))
	_add("scope", _passive("Scope", "+25% Range", 30, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.RANGE, 0.25, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("life_crystal", _passive("Life Crystal", "+1.0 Regen", 40, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.REGENERATION, 1.0, StatModifier.ModifierType.FLAT),
	]))
	_add("dodge_boots", _passive("Dodge Boots", "+10% Dodge", 55, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.DODGE, 0.10, StatModifier.ModifierType.FLAT),
	]))
	_add("skull_ring", _passive("Skull Ring", "+15% Crit Multiplier", 60, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.CRIT_MULTIPLIER, 0.15, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("magnet_ring", _passive("Magnet Ring", "+30 Pickup Range", 25, Rarity.Tier.COMMON, [
		_mod(StatModifier.Stat.PICKUP_RANGE, 30.0, StatModifier.ModifierType.FLAT),
	]))
	_add("heavy_plate", _passive("Heavy Plate", "+10 Armor, -15 Speed", 70, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.ARMOR, 10.0, StatModifier.ModifierType.FLAT),
		_mod(StatModifier.Stat.SPEED, -15.0, StatModifier.ModifierType.FLAT),
	]))
	_add("adrenaline", _passive("Adrenaline", "+15% Atk Speed, +5% Dodge", 75, Rarity.Tier.EPIC, [
		_mod(StatModifier.Stat.ATTACK_SPEED, 0.15, StatModifier.ModifierType.PERCENTAGE),
		_mod(StatModifier.Stat.DODGE, 0.05, StatModifier.ModifierType.FLAT),
	]))
	_add("vampiric_fang", _passive("Vampiric Fang", "+8% Life Steal", 65, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.LIFE_STEAL, 0.08, StatModifier.ModifierType.FLAT),
	]))

	# Consumables
	_add("health_potion", _consumable("Health Potion", "Heal 30 HP", 15, Rarity.Tier.COMMON))
	_add("mega_health_potion", _consumable("Mega Health Potion", "Heal 75 HP", 30, Rarity.Tier.UNCOMMON))
	_add("xp_orb", _consumable("XP Orb", "Gain 50 XP", 20, Rarity.Tier.COMMON))
	_add("gold_chest", _consumable("Gold Chest", "Gain 50 Gold", 25, Rarity.Tier.UNCOMMON))
	_add("reroll_token", _consumable("Reroll Token", "Reroll upgrade choices", 30, Rarity.Tier.UNCOMMON))

	# Relics
	_add("crown", _relic("Crown", "+20% Gold Bonus", 100, Rarity.Tier.EPIC, [
		_mod(StatModifier.Stat.GOLD_BONUS, 0.20, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("philosopher_stone", _relic("Philosopher's Stone", "+15% XP Bonus", 80, Rarity.Tier.EPIC, [
		_mod(StatModifier.Stat.XP_BONUS, 0.15, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("thorn_ring", _relic("Thorn Ring", "+20 Knockback", 60, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.KNOCKBACK_FORCE, 20.0, StatModifier.ModifierType.FLAT),
	]))
	_add("lucky_coin", _relic("Lucky Coin", "+10% Gold Bonus", 45, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.GOLD_BONUS, 0.10, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("ancient_tablet", _relic("Ancient Tablet", "+10% XP Bonus", 50, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.XP_BONUS, 0.10, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("damage_gem", _relic("Damage Gem", "+10% Damage", 70, Rarity.Tier.RARE, [
		_mod(StatModifier.Stat.DAMAGE, 0.10, StatModifier.ModifierType.PERCENTAGE),
	]))
	_add("fortress_ring", _relic("Fortress Ring", "+5 Armor, +25 Max Health", 85, Rarity.Tier.EPIC, [
		_mod(StatModifier.Stat.ARMOR, 5.0, StatModifier.ModifierType.FLAT),
		_mod(StatModifier.Stat.MAX_HEALTH, 25.0, StatModifier.ModifierType.FLAT),
	]))
	_add("harvest_scythe", _relic("Harvest Scythe", "+5 Harvesting", 55, Rarity.Tier.UNCOMMON, [
		_mod(StatModifier.Stat.HARVESTING, 5.0, StatModifier.ModifierType.FLAT),
	]))

func _add(key: String, item: ItemData) -> void:
	_items[key] = item

func _passive(n: String, desc: String, cost: int, rar: Rarity.Tier, mods: Array) -> ItemData:
	var item := ItemData.new()
	item.item_name = n
	item.description = desc
	item.item_type = ItemData.ItemType.PASSIVE
	item.rarity = rar
	item.cost = cost
	item.modifiers = mods
	return item

func _consumable(n: String, desc: String, cost: int, rar: Rarity.Tier) -> ItemData:
	var item := ItemData.new()
	item.item_name = n
	item.description = desc
	item.item_type = ItemData.ItemType.CONSUMABLE
	item.rarity = rar
	item.cost = cost
	return item

func _relic(n: String, desc: String, cost: int, rar: Rarity.Tier, mods: Array) -> ItemData:
	var item := ItemData.new()
	item.item_name = n
	item.description = desc
	item.item_type = ItemData.ItemType.RELIC
	item.rarity = rar
	item.cost = cost
	item.modifiers = mods
	return item

func _mod(stat: StatModifier.Stat, value: float, type: StatModifier.ModifierType) -> StatModifier:
	var m := StatModifier.new()
	m.stat = stat
	m.value = value
	m.modifier_type = type
	return m

func get_item(key: String) -> ItemData:
	return _items.get(key)

func get_all_items() -> Dictionary:
	return _items

func get_items_by_type(item_type: ItemData.ItemType) -> Array[ItemData]:
	var result: Array[ItemData] = []
	for key in _items:
		if _items[key].item_type == item_type:
			result.append(_items[key])
	return result

func get_items_by_rarity(rarity: Rarity.Tier) -> Array[ItemData]:
	var result: Array[ItemData] = []
	for key in _items:
		if _items[key].rarity == rarity:
			result.append(_items[key])
	return result

func get_random_items(count: int, exclude: Array = []) -> Array[ItemData]:
	var available: Array[ItemData] = []
	for key in _items:
		if _items[key] not in exclude:
			available.append(_items[key])
	available.shuffle()
	return available.slice(0, mini(count, available.size()))
