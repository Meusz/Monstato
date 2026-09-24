extends "res://enemies/enemy_base.gd"

## RangedEnemy - Legacy wrapper. Ranged logic now in enemy_base.gd.

func _ready() -> void:
	super._ready()
	if not enemy_data:
		set_data(load("res://enemies/data/ranged_enemy_data.tres"))
