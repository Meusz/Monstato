class_name KnockbackComponent
extends Node

## Component that applies knockback forces to CharacterBody2D entities.
## Attach to player or enemies that should be affected by knockback.

@export var friction: float = 1200.0
@export var max_force: float = 600.0

var _knockback_velocity: Vector2 = Vector2.ZERO
var _parent: CharacterBody2D

func _ready() -> void:
	_parent = get_parent() as CharacterBody2D
	if not _parent:
		push_warning("KnockbackComponent must be a child of a CharacterBody2D")

func _physics_process(delta: float) -> void:
	if _knockback_velocity.length() > 1.0:
		_knockback_velocity = _knockback_velocity.move_toward(Vector2.ZERO, friction * delta)
	else:
		_knockback_velocity = Vector2.ZERO

## Applies a knockback force in a given direction.
func apply_knockback(direction: Vector2, force: float) -> void:
	var clamped_force := clampf(force, 0.0, max_force)
	_knockback_velocity = direction.normalized() * clamped_force

## Applies knockback away from a source position.
func apply_knockback_from(source_position: Vector2, force: float) -> void:
	if not _parent:
		return
	var direction := (_parent.global_position - source_position).normalized()
	apply_knockback(direction, force)

## Returns the current knockback velocity.
func get_knockback_velocity() -> Vector2:
	return _knockback_velocity

## Returns whether knockback is currently being applied.
func is_knocked_back() -> bool:
	return _knockback_velocity.length() > 1.0

## Clears all current knockback.
func clear_knockback() -> void:
	_knockback_velocity = Vector2.ZERO
