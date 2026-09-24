class_name HealthComponent
extends Node

## Manages health, damage, healing, dodge, and death.

signal health_changed(new_health: float, max_health: float)
signal damage_taken(amount: float, source: Node)
signal healed(amount: float)
signal died
signal dodged

@export var max_health: float = 100.0
@export var armor: float = 0.0
@export var invincibility_time: float = 0.0

var current_health: float
var _is_dead: bool = false
var _is_invincible: bool = false
var _invincibility_timer: float = 0.0
var _life_steal_cooldown: float = 0.0
var _life_steal_cap: float = 10.0

func _ready() -> void:
	current_health = max_health

func _process(delta: float) -> void:
	if _is_invincible:
		_invincibility_timer -= delta
		if _invincibility_timer <= 0.0:
			_is_invincible = false
	if _life_steal_cooldown > 0.0:
		_life_steal_cooldown -= delta

func take_damage(amount: float, source: Node = null) -> void:
	if _is_dead or _is_invincible:
		return
	# Dodge check (only for player)
	if source and source.is_in_group("enemies"):
		var dodge_chance: float = DataBus.player_stats.get("dodge", 0.0)
		if randf() < mini(int(dodge_chance * 100), 60) / 100.0:
			dodged.emit()
			return
	var final_damage := _calculate_damage(amount)
	current_health -= final_damage
	current_health = maxf(current_health, 0.0)
	health_changed.emit(current_health, max_health)
	damage_taken.emit(final_damage, source)
	DataBus.run_stats["total_damage_taken"] += final_damage
	if invincibility_time > 0.0:
		_start_invincibility()
	if current_health <= 0.0:
		_die()

func try_life_steal() -> void:
	var ls: float = DataBus.player_stats.get("life_steal", 0.0)
	if ls <= 0.0 or _life_steal_cooldown > 0.0:
		return
	if randf() < ls:
		heal(1.0)
		_life_steal_cooldown = 0.1

func heal(amount: float) -> void:
	if _is_dead:
		return
	var old_health := current_health
	current_health = minf(current_health + amount, max_health)
	if current_health > old_health:
		var actual_heal := current_health - old_health
		healed.emit(actual_heal)
		health_changed.emit(current_health, max_health)

func _calculate_damage(raw_damage: float) -> float:
	var reduction := armor / (armor + 100.0)
	return raw_damage * (1.0 - reduction)

func _start_invincibility() -> void:
	_is_invincible = true
	_invincibility_timer = invincibility_time

func _die() -> void:
	if _is_dead:
		return
	_is_dead = true
	died.emit()

func reset_health() -> void:
	current_health = max_health
	_is_dead = false
	_is_invincible = false
	health_changed.emit(current_health, max_health)

func set_max_health(value: float, heal_to_max: bool = true) -> void:
	max_health = value
	if heal_to_max:
		current_health = max_health
	health_changed.emit(current_health, max_health)

func set_armor(value: float) -> void:
	armor = value

func is_dead() -> bool:
	return _is_dead

func is_invincible() -> bool:
	return _is_invincible

func get_health_percent() -> float:
	if max_health <= 0.0:
		return 0.0
	return current_health / max_health
