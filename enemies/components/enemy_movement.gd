extends Node

## EnemyMovement - Handles enemy movement toward target.

@export var speed: float = 100.0
@export var acceleration: float = 400.0

func move_toward_target(body: CharacterBody2D, target: Node2D) -> void:
	if not target:
		return
	var direction := (target.global_position - body.global_position).normalized()
	body.velocity = body.velocity.move_toward(direction * speed, acceleration * body.get_physics_process_delta_time())
