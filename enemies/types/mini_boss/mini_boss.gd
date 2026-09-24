extends "res://enemies/enemy_base.gd"

## MiniBoss - Stronger enemy with special attacks.

func _ready() -> void:
	super._ready()
	if not enemy_data:
		set_data(load("res://enemies/data/mini_boss_data.tres"))
	scale = enemy_data.scale if enemy_data else 2.0
	$Sprite2D.scale = Vector2.ONE * scale
	EventBus.boss_spawned.emit(self)

func _on_died() -> void:
	EventBus.boss_defeated.emit(self)
	super._on_died()
