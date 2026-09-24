extends "res://enemies/enemy_base.gd"

## TankEnemy - High HP, slow enemy with armor.
## Acts as a damage sponge.

func _ready() -> void:
	super._ready()
	if not enemy_data:
		set_data(load("res://enemies/data/tank_enemy_data.tres"))
	scale = enemy_data.scale if enemy_data else 1.5
	$Sprite2D.scale = Vector2.ONE * scale
