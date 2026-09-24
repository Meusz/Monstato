extends Control

## VirtualJoystick - Touch-only virtual joystick for mobile.
## Only responds to touch input (InputEventScreenTouch/InputEventScreenDrag).

signal direction_changed(direction: Vector2)

@export var base_radius: float = 75.0
@export var knob_max_distance: float = 55.0

var current_direction: Vector2 = Vector2.ZERO
var _touch_index: int = -1
var _base_center: Vector2 = Vector2.ZERO

@onready var base_rect: ColorRect = $Base
@onready var knob: ColorRect = $Base/Knob

func _ready() -> void:
	_update_base_center()
	resized.connect(_update_base_center)

func _update_base_center() -> void:
	_base_center = base_rect.global_position + base_rect.size / 2.0
	knob.position = -knob.size / 2.0

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			_handle_touch(event.position, event.index, true)
		else:
			_handle_release(event.index)
	elif event is InputEventScreenDrag:
		_handle_drag(event.position, event.index)

func _handle_touch(pos: Vector2, index: int, pressed: bool) -> void:
	if not pressed:
		return
	var local_pos: Vector2 = base_rect.global_position
	var half_size: Vector2 = base_rect.size / 2.0
	var rect_min: Vector2 = local_pos - half_size
	var rect_max: Vector2 = local_pos + half_size
	if pos.x >= rect_min.x and pos.x <= rect_max.x and pos.y >= rect_min.y and pos.y <= rect_max.y:
		_touch_index = index
		_update_knob(pos)

func _handle_drag(pos: Vector2, index: int) -> void:
	if index != _touch_index:
		return
	_update_knob(pos)

func _handle_release(index: int) -> void:
	if index == _touch_index:
		_reset_joystick()

func _update_knob(touch_pos: Vector2) -> void:
	var offset: Vector2 = touch_pos - _base_center
	var distance: float = offset.length()
	if distance > knob_max_distance:
		offset = offset.normalized() * knob_max_distance
	knob.position = offset - knob.size / 2.0
	if distance > 5.0:
		current_direction = offset.normalized()
		direction_changed.emit(current_direction)
	else:
		current_direction = Vector2.ZERO
		direction_changed.emit(Vector2.ZERO)

func _reset_joystick() -> void:
	_touch_index = -1
	knob.position = -knob.size / 2.0
	current_direction = Vector2.ZERO
	direction_changed.emit(Vector2.ZERO)
