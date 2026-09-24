extends Node

## PlayerInput - Handles player input processing.
## Separates input logic from other player systems.

var _touch_buttons: Control = null
var _last_dash_state: bool = false
var _last_ability_state: bool = false

func _ready() -> void:
	_touch_buttons = get_node_or_null("/root/TouchButtons")

func get_input_direction() -> Vector2:
	var joystick: Control = get_node_or_null("/root/VirtualJoystick")
	if joystick and is_instance_valid(joystick):
		var dir: Vector2 = joystick.current_direction
		if dir != Vector2.ZERO:
			return dir
	var direction := Vector2.ZERO
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	return direction.normalized()

func is_dash_pressed() -> bool:
	var keyboard_dash: bool = Input.is_action_just_pressed("dash")
	var touch_dash: bool = false
	if _touch_buttons and is_instance_valid(_touch_buttons):
		touch_dash = _touch_buttons.is_dash_just_pressed()
	return keyboard_dash or touch_dash

func is_ability_pressed() -> bool:
	var keyboard_ability: bool = Input.is_action_just_pressed("ability")
	var touch_ability: bool = false
	if _touch_buttons and is_instance_valid(_touch_buttons):
		touch_ability = _touch_buttons.is_ability_just_pressed()
	return keyboard_ability or touch_ability

func is_interact_pressed() -> bool:
	return Input.is_action_just_pressed("interact")
