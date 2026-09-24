class_name EnemyData
extends Resource

## Resource that defines all properties for an enemy type.

@export var enemy_name: String = "Enemy"
@export var health: float = 30.0
@export var armor: float = 0.0
@export var damage: float = 5.0
@export var speed: float = 80.0
@export var attack_range: float = 30.0
@export var attack_cooldown: float = 1.0
@export var xp_value: int = 10
@export var detection_range: float = 200.0
@export var color: Color = Color.RED
@export var scale: float = 1.0
@export var type: String = "melee"
@export var element: CompanionData.CompanionType = CompanionData.CompanionType.FIRE
@export var scene: PackedScene

func get_element_color() -> Color:
	match element:
		CompanionData.CompanionType.FIRE:
			return Color(0.91, 0.3, 0.24)
		CompanionData.CompanionType.GRASS:
			return Color(0.18, 0.8, 0.44)
		CompanionData.CompanionType.WATER:
			return Color(0.2, 0.6, 0.86)
	return Color.RED
