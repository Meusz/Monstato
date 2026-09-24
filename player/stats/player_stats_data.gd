class_name PlayerStatsData
extends Resource

## Resource that defines initial player stats for a character class.
## Used to configure different playable characters.

@export var character_name: String = "Default"
@export var description: String = ""
@export var portrait: Texture2D

@export_group("Base Stats")
@export var max_health: float = 100.0
@export var armor: float = 0.0
@export var speed: float = 200.0
@export var regeneration: float = 0.0
@export var luck: float = 0.0

@export_group("Combat Stats")
@export var damage: float = 10.0
@export var crit_chance: float = 0.05
@export var crit_multiplier: float = 2.0
@export var attack_speed: float = 1.0
@export var range: float = 150.0
@export var projectile_count: int = 1
@export var knockback_force: float = 100.0

@export_group("Utility Stats")
@export var pickup_range: float = 50.0
@export var xp_bonus: float = 0.0
@export var gold_bonus: float = 0.0

@export_group("Starting Loadout")
@export var starting_weapons: Array = ["pistol"]
@export var starting_items: Array = []

## Converts this resource to a Dictionary for DataBus.
func to_dict() -> Dictionary:
	return {
		"max_health": max_health,
		"health": max_health,
		"armor": armor,
		"speed": speed,
		"regeneration": regeneration,
		"luck": luck,
		"damage": damage,
		"crit_chance": crit_chance,
		"crit_multiplier": crit_multiplier,
		"attack_speed": attack_speed,
		"range": range,
		"projectile_count": projectile_count,
		"knockback_force": knockback_force,
		"pickup_range": pickup_range,
		"xp_bonus": xp_bonus,
		"gold_bonus": gold_bonus,
	}
