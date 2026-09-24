extends Node

## PlayerStats - Manages player stat calculations and modifiers.
## Stats are synced with DataBus.player_stats.

var _stats: Dictionary = {}
var _modifiers: Dictionary = {}

func _ready() -> void:
	_stats = DataBus.player_stats.duplicate()

func _process(delta: float) -> void:
	_apply_regen(delta)

func _apply_regen(delta: float) -> void:
	var regen := get_stat("regeneration")
	if regen > 0.0:
		var current_health := get_stat("health")
		var max_health := get_stat("max_health")
		if current_health < max_health:
			var new_health := minf(current_health + regen * delta, max_health)
			set_stat("health", new_health)

func set_stats(new_stats: Dictionary) -> void:
	_stats = new_stats.duplicate()

func get_stats() -> Dictionary:
	return _stats

func get_stat(stat_name: String) -> float:
	return _stats.get(stat_name, 0.0)

func set_stat(stat_name: String, value: float) -> void:
	_stats[stat_name] = value
	DataBus.player_stats[stat_name] = value

func modify_stat(stat_name: String, amount: float) -> void:
	_stats[stat_name] += amount
	DataBus.player_stats[stat_name] = _stats[stat_name]

func add_modifier(stat_name: String, modifier_id: String, value: float, is_percentage: bool = false) -> void:
	if not _modifiers.has(stat_name):
		_modifiers[stat_name] = {}
	_modifiers[stat_name][modifier_id] = {"value": value, "is_percentage": is_percentage}
	_recalculate_stat(stat_name)

func remove_modifier(stat_name: String, modifier_id: String) -> void:
	if _modifiers.has(stat_name) and _modifiers[stat_name].has(modifier_id):
		_modifiers[stat_name].erase(modifier_id)
		_recalculate_stat(stat_name)

func _recalculate_stat(stat_name: String) -> void:
	var base_value: float = DataBus.player_stats.get(stat_name, 0.0)
	var flat_bonus := 0.0
	var mult_bonus := 1.0
	if _modifiers.has(stat_name):
		for mod_id in _modifiers[stat_name]:
			var mod = _modifiers[stat_name][mod_id]
			if mod["is_percentage"]:
				mult_bonus += mod["value"]
			else:
				flat_bonus += mod["value"]
	_stats[stat_name] = (base_value + flat_bonus) * mult_bonus
	DataBus.player_stats[stat_name] = _stats[stat_name]
