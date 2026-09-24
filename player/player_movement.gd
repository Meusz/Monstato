extends Node

## PlayerMovement - Handles player movement and dashing.

@export var acceleration: float = 800.0
@export var deceleration: float = 1000.0

func handle_movement(body: CharacterBody2D, input_dir: Vector2, knockback: Vector2, speed: float, delta: float) -> void:
	var target_velocity := input_dir * speed
	if input_dir != Vector2.ZERO:
		body.velocity = body.velocity.move_toward(target_velocity, acceleration * delta)
	else:
		body.velocity = body.velocity.move_toward(Vector2.ZERO, deceleration * delta)
	body.velocity += knockback
