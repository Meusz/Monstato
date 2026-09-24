extends Node

## PlayerAnimations - Controls player animation states.

@onready var _sprite: Sprite2D = null
var _last_direction: Vector2 = Vector2.RIGHT
var _bob_timer: float = 0.0
var _bob_speed: float = 8.0
var _bob_amount: float = 2.0
var _is_moving: bool = false
var _original_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	_sprite = get_parent().get_node_or_null("Sprite2D")
	if _sprite:
		_original_position = _sprite.position

func _process(delta: float) -> void:
	if not _sprite:
		return
	if _is_moving:
		_bob_timer += delta * _bob_speed
		_sprite.position.y = _original_position.y + sin(_bob_timer) * _bob_amount
	else:
		_sprite.position.y = _original_position.y
		_bob_timer = 0.0

func update_animation(direction: Vector2) -> void:
	_is_moving = direction != Vector2.ZERO
	if _is_moving:
		_last_direction = direction
		_play_walk_animation()
	else:
		_play_idle_animation()

func _play_walk_animation() -> void:
	if _sprite:
		_sprite.flip_h = _last_direction.x < 0

func _play_idle_animation() -> void:
	pass

func play_dash_effect() -> void:
	if not _sprite:
		return
	_sprite.modulate = Color(0.5, 0.8, 1.0, 0.7)
	await get_tree().create_timer(0.15).timeout
	if _sprite:
		_sprite.modulate = Color.WHITE

func play_damage_flash() -> void:
	if not _sprite:
		return
	_sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	if _sprite:
		_sprite.modulate = Color.WHITE
