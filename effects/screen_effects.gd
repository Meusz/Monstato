extends CanvasLayer

## ScreenEffects - Manages visual effects like screen shake, flash, and slow motion.

var _shake_intensity: float = 0.0
var _shake_duration: float = 0.0
var _shake_timer: float = 0.0
var _shake_offset: Vector2 = Vector2.ZERO

var _flash_color: Color = Color.WHITE
var _flash_duration: float = 0.0
var _flash_timer: float = 0.0

var _slow_motion_active: bool = false
var _slow_motion_scale: float = 0.3
var _slow_motion_duration: float = 0.0
var _slow_motion_timer: float = 0.0

@onready var flash_rect: ColorRect = $FlashRect

func _ready() -> void:
	EventBus.player_damaged.connect(_on_player_damaged)
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.critical_hit.connect(_on_critical_hit)

func _process(delta: float) -> void:
	_process_shake(delta)
	_process_flash(delta)
	_process_slow_motion(delta)

func _process_shake(delta: float) -> void:
	var camera: Camera2D = get_viewport().get_camera_2d()
	if _shake_timer > 0.0:
		_shake_timer -= delta
		_shake_offset = Vector2(
			randf_range(-_shake_intensity, _shake_intensity),
			randf_range(-_shake_intensity, _shake_intensity)
		) * (_shake_timer / _shake_duration)
		if camera:
			camera.offset = -_shake_offset
	else:
		_shake_offset = Vector2.ZERO
		if camera:
			camera.offset = Vector2.ZERO

func _process_flash(delta: float) -> void:
	if _flash_timer > 0.0:
		_flash_timer -= delta
		var alpha := _flash_timer / _flash_duration
		flash_rect.color = Color(_flash_color.r, _flash_color.g, _flash_color.b, alpha)
		flash_rect.visible = true
	else:
		flash_rect.visible = false

func _process_slow_motion(delta: float) -> void:
	if _slow_motion_active:
		_slow_motion_timer -= delta
		Engine.time_scale = _slow_motion_scale
		if _slow_motion_timer <= 0.0:
			Engine.time_scale = 1.0
			_slow_motion_active = false

## Triggers screen shake effect.
func shake(intensity: float = 5.0, duration: float = 0.2) -> void:
	var screen_shake_enabled: bool = SaveSystem.get_setting("screen_shake", true)
	if not screen_shake_enabled:
		return
	_shake_intensity = intensity
	_shake_duration = duration
	_shake_timer = duration

## Triggers screen flash effect.
func flash(color: Color = Color.WHITE, duration: float = 0.1) -> void:
	_flash_color = color
	_flash_duration = duration
	_flash_timer = duration

## Triggers slow motion effect.
func slow_motion(scale: float = 0.3, duration: float = 0.5) -> void:
	_slow_motion_active = true
	_slow_motion_scale = scale
	_slow_motion_duration = duration
	_slow_motion_timer = duration

func _on_player_damaged(_amount: float, _source: Node) -> void:
	shake(8.0, 0.3)
	flash(Color.RED, 0.1)

func _on_enemy_killed(_enemy: Node, _xp: int) -> void:
	shake(2.0, 0.1)

func _on_critical_hit(_target: Node, _amount: float) -> void:
	pass
