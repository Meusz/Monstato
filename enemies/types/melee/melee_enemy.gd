extends "res://enemies/enemy_base.gd"

## MeleeEnemy - Basic melee enemy that charges at the player.

func _ready() -> void:
	super._ready()
	if not enemy_data:
		set_data(load("res://enemies/data/melee_enemy_data.tres"))
