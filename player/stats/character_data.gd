class_name CharacterData
extends Resource

## Resource that defines a playable character.

@export var character_name: String = "Default"
@export var description: String = ""
@export var portrait: Texture2D
@export var sprite_color: Color = Color(0.2, 0.6, 1.0)
@export var unlock_condition: String = ""

@export_group("Primary Stats")
@export var max_health: float = 100.0
@export var regeneration: float = 0.0
@export var life_steal: float = 0.0
@export var damage: float = 0.0
@export var melee_damage: float = 0.0
@export var ranged_damage: float = 0.0
@export var elemental_damage: float = 0.0
@export var attack_speed: float = 0.0
@export var crit_chance: float = 0.05
@export var crit_multiplier: float = 2.0
@export var engineering: float = 0.0
@export var range: float = 0.0
@export var armor: float = 0.0
@export var dodge: float = 0.0
@export var speed: float = 200.0
@export var luck: float = 0.0
@export var harvesting: float = 0.0
@export var curse: float = 0.0

@export_group("Combat Modifiers")
@export var projectile_count: int = 0
@export var knockback_force: float = 100.0

@export_group("Utility Stats")
@export var pickup_range: float = 50.0
@export var xp_bonus: float = 0.0
@export var gold_bonus: float = 0.0

@export_group("Starting Loadout")
@export var starting_weapons: Array = ["pistol"]
@export var starting_items: Array = []

func to_dict() -> Dictionary:
	return {
		"character_name": character_name,
		"max_health": max_health,
		"health": max_health,
		"regeneration": regeneration,
		"life_steal": life_steal,
		"damage": damage,
		"melee_damage": melee_damage,
		"ranged_damage": ranged_damage,
		"elemental_damage": elemental_damage,
		"attack_speed": attack_speed,
		"crit_chance": crit_chance,
		"crit_multiplier": crit_multiplier,
		"engineering": engineering,
		"range": range,
		"armor": armor,
		"dodge": dodge,
		"speed": speed,
		"luck": luck,
		"harvesting": harvesting,
		"curse": curse,
		"projectile_count": projectile_count,
		"knockback_force": knockback_force,
		"pickup_range": pickup_range,
		"xp_bonus": xp_bonus,
		"gold_bonus": gold_bonus,
	}
