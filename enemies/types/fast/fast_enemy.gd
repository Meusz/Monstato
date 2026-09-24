extends "res://enemies/enemy_base.gd"

## FastEnemy - Quick, low HP enemy that rushes the player.

func _ready() -> void:
	super._ready()
	if not enemy_data:
		set_data(load("res://enemies/data/fast_enemy_data.tres"))
