class_name AbilityData
extends Resource

## Resource that defines a trainer active ability.

enum AbilityType { AOE, PROJECTILE, BUFF, BURST }

@export var ability_name: String = "Ability"
@export var ability_key: String = ""
@export var description: String = ""
@export var cooldown: float = 5.0
@export var damage_multiplier: float = 1.0
@export var radius: float = 100.0
@export var duration: float = 0.0
@export var ability_type: AbilityType = AbilityType.AOE

func get_icon_color() -> Color:
	match ability_key:
		"whirlwind": return Color(1.0, 0.4, 0.2)
		"snipe": return Color(0.2, 0.8, 0.2)
		"fortify": return Color(0.3, 0.5, 1.0)
		"elemental_blast": return Color(0.9, 0.9, 0.2)
	return Color.WHITE

func get_type_label() -> String:
	match ability_type:
		AbilityType.AOE: return "AoE"
		AbilityType.PROJECTILE: return "Projectile"
		AbilityType.BUFF: return "Buff"
		AbilityType.BURST: return "Burst"
	return "Unknown"
