class_name ItemData
extends Resource

## Resource that defines an item's properties and effects.

enum ItemType { PASSIVE, CONSUMABLE, RELIC }

@export var item_name: String = "Item"
@export var description: String = ""
@export var item_type: ItemType = ItemType.PASSIVE
@export var rarity: Rarity.Tier = Rarity.Tier.COMMON
@export var cost: int = 10
@export var icon: Texture2D
@export var max_stack: int = 1
@export var modifiers: Array = []

func get_rarity_color() -> Color:
	return Rarity.get_color(rarity)

func get_rarity_name() -> String:
	return Rarity.get_tier_name(rarity)

func apply_modifiers() -> void:
	for mod in modifiers:
		mod.apply(DataBus.player_stats)

func remove_modifiers() -> void:
	for mod in modifiers:
		mod.remove(DataBus.player_stats)
