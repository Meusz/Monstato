extends "res://enemies/enemy_base.gd"

## Boss - Main boss enemy with multiple attack phases.

func _ready() -> void:
	super._ready()
	if not enemy_data:
		set_data(load("res://enemies/data/boss_data.tres"))
	scale = enemy_data.scale if enemy_data else 3.0
	$Sprite2D.scale = Vector2.ONE * scale
	EventBus.boss_spawned.emit(self)

func _on_died() -> void:
	EventBus.boss_defeated.emit(self)
	EventBus.game_over.emit(true)
	super._on_died()
