extends Node

## DashAbility - Handles the player's dash mechanic.

@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.15
@export var dash_cooldown: float = 0.8

var _can_dash: bool = true
var _is_dashing: bool = false
var _dash_timer: float = 0.0
var _cooldown_timer: float = 0.0
var _dash_direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if _is_dashing:
		_dash_timer -= delta
		if _dash_timer <= 0.0:
			_end_dash()
	if not _can_dash:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0.0:
			_can_dash = true

func try_dash(direction: Vector2) -> bool:
	if not _can_dash or _is_dashing:
		return false
	_start_dash(direction)
	return true

func _start_dash(direction: Vector2) -> void:
	_is_dashing = true
	_can_dash = false
	_dash_timer = dash_duration
	_cooldown_timer = dash_cooldown
	_dash_direction = direction if direction != Vector2.ZERO else Vector2.RIGHT
	EventBus.dash_used.emit()

func _end_dash() -> void:
	_is_dashing = false

func is_dashing() -> bool:
	return _is_dashing

func get_dash_velocity() -> Vector2:
	if _is_dashing:
		return _dash_direction.normalized() * dash_speed
	return Vector2.ZERO
