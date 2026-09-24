extends Node

## WeaponManager - Manages equipped weapons for the player.
## Handles adding, removing, and switching weapons.

var _weapons: Array[Node2D] = []
var _current_index: int = 0

func add_weapon(weapon: Node2D) -> bool:
	if _weapons.size() >= DataBus.max_weapons:
		return false
	_weapons.append(weapon)
	EventBus.weapon_changed.emit(_current_index, weapon.weapon_data)
	return true

func remove_weapon(index: int) -> void:
	if index >= 0 and index < _weapons.size():
		var weapon := _weapons[index]
		_weapons.remove_at(index)
		weapon.queue_free()
		if _current_index >= _weapons.size():
			_current_index = maxi(0, _weapons.size() - 1)

func switch_weapon(direction: int) -> void:
	if _weapons.is_empty():
		return
	_current_index = (_current_index + direction) % _weapons.size()
	EventBus.weapon_changed.emit(_current_index, _weapons[_current_index].weapon_data)

func get_current_weapon() -> Node2D:
	if _current_index < _weapons.size():
		return _weapons[_current_index]
	return null

func get_all_weapons() -> Array[Node2D]:
	return _weapons

func get_weapon_count() -> int:
	return _weapons.size()
