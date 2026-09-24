extends Control

## TouchButtons - Touch-only action buttons for mobile.
## Supports multi-touch: each button tracks its own touch index.

var _dash_touch_index: int = -1
var _ability_touch_index: int = -1
var _dash_just_pressed: bool = false
var _ability_just_pressed: bool = false

@onready var dash_button: ColorRect = $DashButton
@onready var dash_label: Label = $DashButton/Label
@onready var ability_button: ColorRect = $AbilityButton
@onready var ability_label: Label = $AbilityButton/Label

var _dash_pressed_state: bool = false
var _ability_pressed_state: bool = false

func _ready() -> void:
	_setup_button(dash_button, Color(0.8, 0.2, 0.2, 0.6), Color(1.0, 0.3, 0.3, 0.8))
	_setup_button(ability_button, Color(0.2, 0.3, 0.8, 0.6), Color(0.3, 0.5, 1.0, 0.8))
	dash_label.text = "DASH"
	ability_label.text = "ABILITY"
	dash_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dash_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ability_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ability_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

func _setup_button(btn: ColorRect, normal_color: Color, pressed_color: Color) -> void:
	btn.custom_minimum_size = Vector2(120.0, 120.0)
	btn.size = btn.custom_minimum_size
	btn.color = normal_color
	btn.mouse_filter = Control.MOUSE_FILTER_PASS

func _input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return

	if event is InputEventScreenTouch:
		if event.pressed:
			_check_button_touch(event.position, event.index, true)
		else:
			_check_button_release(event.index)
	elif event is InputEventScreenDrag:
		_check_button_drag(event.position, event.index)

func _check_button_touch(pos: Vector2, index: int, pressed: bool) -> void:
	if not pressed:
		return

	var dash_rect: Rect2 = _get_global_rect(dash_button)
	var ability_rect: Rect2 = _get_global_rect(ability_button)

	if dash_rect.has_point(pos) and _dash_touch_index == -1:
		_dash_touch_index = index
		_dash_pressed_state = true
		_dash_just_pressed = true
		_animate_press(dash_button, true)
	elif ability_rect.has_point(pos) and _ability_touch_index == -1:
		_ability_touch_index = index
		_ability_pressed_state = true
		_ability_just_pressed = true
		EventBus.ability_requested.emit()
		_animate_press(ability_button, true)

func _check_button_drag(pos: Vector2, index: int) -> void:
	var dash_rect: Rect2 = _get_global_rect(dash_button)
	var ability_rect: Rect2 = _get_global_rect(ability_button)

	if index == _dash_touch_index:
		_dash_pressed_state = dash_rect.has_point(pos)
		if not _dash_pressed_state:
			_animate_press(dash_button, false)
	elif index == _ability_touch_index:
		_ability_pressed_state = ability_rect.has_point(pos)
		if not _ability_pressed_state:
			_animate_press(ability_button, false)

func _check_button_release(index: int) -> void:
	if index == _dash_touch_index:
		_dash_touch_index = -1
		_dash_pressed_state = false
		_animate_press(dash_button, false)
	elif index == _ability_touch_index:
		_ability_touch_index = -1
		_ability_pressed_state = false
		_animate_press(ability_button, false)

func _get_global_rect(ctrl: Control) -> Rect2:
	return Rect2(ctrl.global_position, ctrl.size)

func _animate_press(btn: Control, pressed: bool) -> void:
	btn.modulate = Color(1.5, 1.5, 1.5, btn.modulate.a) if pressed else Color(1.0, 1.0, 1.0, btn.modulate.a)

func is_dash_just_pressed() -> bool:
	var result: bool = _dash_just_pressed
	return result

func is_ability_just_pressed() -> bool:
	var result: bool = _ability_just_pressed
	return result

func _process(_delta: float) -> void:
	_dash_just_pressed = false
	_ability_just_pressed = false
