class_name Rarity
extends Resource

## Resource that defines the rarity tier of an item or equipment.

enum Tier {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
}

@export var tier: Tier = Tier.COMMON
@export var color: Color = Color.WHITE
@export var name: String = "Common"
@export var drop_weight: float = 100.0

## Returns the color associated with this rarity tier.
static func get_color(t: Tier) -> Color:
	match t:
		Tier.COMMON: return Color(0.6, 0.6, 0.6)
		Tier.UNCOMMON: return Color(0.2, 0.8, 0.2)
		Tier.RARE: return Color(0.2, 0.4, 1.0)
		Tier.EPIC: return Color(0.7, 0.2, 0.9)
		Tier.LEGENDARY: return Color(1.0, 0.8, 0.0)
	return Color.WHITE

## Returns the name of this rarity tier.
static func get_tier_name(t: Tier) -> String:
	match t:
		Tier.COMMON: return "Common"
		Tier.UNCOMMON: return "Uncommon"
		Tier.RARE: return "Rare"
		Tier.EPIC: return "Epic"
		Tier.LEGENDARY: return "Legendary"
	return "Unknown"

## Returns the drop weight (probability) for this rarity.
static func get_drop_weight(t: Tier) -> float:
	match t:
		Tier.COMMON: return 100.0
		Tier.UNCOMMON: return 50.0
		Tier.RARE: return 20.0
		Tier.EPIC: return 8.0
		Tier.LEGENDARY: return 2.0
	return 0.0

## Creates a Rarity resource for a given tier.
static func create(t: Tier) -> Rarity:
	var r := Rarity.new()
	r.tier = t
	r.color = get_color(t)
	r.name = get_tier_name(t)
	r.drop_weight = get_drop_weight(t)
	return r
