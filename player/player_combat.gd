extends Node

## PlayerCombat - Manages weapons and attack logic for the player.

var _weapons: Array = []
var _current_weapon_index: int = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	_update_weapon_cooldowns(delta)
	_try_auto_attack()

func _update_weapon_cooldowns(delta: float) -> void:
	for weapon in _weapons:
		if weapon.has_method("update_cooldown"):
			weapon.update_cooldown(delta)

func _try_auto_attack() -> void:
	for weapon in _weapons:
		if weapon.has_method("can_attack") and weapon.can_attack():
			weapon.attack()

func add_weapon(weapon: Node) -> void:
	_weapons.append(weapon)

func remove_weapon(weapon: Node) -> void:
	_weapons.erase(weapon)

func get_weapons() -> Array:
	return _weapons

func get_weapon_count() -> int:
	return _weapons.size()
