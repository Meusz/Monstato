extends Node

## DataBus - Centralized shared data store.

var player_stats: Dictionary = {}

const DEFAULT_STATS: Dictionary = {
	"max_health": 100.0,
	"health": 100.0,
	"regeneration": 0.0,
	"life_steal": 0.0,
	"damage": 0.0,
	"melee_damage": 0.0,
	"ranged_damage": 0.0,
	"elemental_damage": 0.0,
	"attack_speed": 0.0,
	"crit_chance": 0.05,
	"crit_multiplier": 2.0,
	"engineering": 0.0,
	"range": 0.0,
	"armor": 0.0,
	"dodge": 0.0,
	"speed": 200.0,
	"luck": 0.0,
	"harvesting": 0.0,
	"curse": 0.0,
	"knockback_force": 100.0,
	"pickup_range": 50.0,
	"projectile_count": 0,
	"xp_bonus": 0.0,
	"gold_bonus": 0.0,
}

var currency: int = 0

var current_wave: int = 0
var wave_time_remaining: float = 0.0
var total_enemies_alive: int = 0
var total_enemies_killed: int = 0

var run_stats: Dictionary = {
	"total_kills": 0,
	"total_damage_dealt": 0.0,
	"total_damage_taken": 0.0,
	"total_gold_earned": 0,
	"total_xp_earned": 0,
	"total_waves_survived": 0,
	"highest_wave": 0,
	"best_time": 0.0,
	"items_collected": 0,
	"bosses_defeated": 0,
}

var starting_companion_key: String = ""
var owned_companions: Array = []
var equipped_items: Array = []
var starting_weapons: Array = ["pistol"]
var max_deployed: int = 4
var max_reserve: int = 3
var max_items: int = 6
var max_weapons: int = 4

var active_effects: Dictionary = {}
var death_reason: String = ""

func _ready() -> void:
	reset_runtime_data()

func reset_runtime_data() -> void:
	player_stats = DEFAULT_STATS.duplicate()
	currency = 0
	current_wave = 0
	wave_time_remaining = 0.0
	total_enemies_alive = 0
	total_enemies_killed = 0
	starting_companion_key = ""
	owned_companions = []
	equipped_items = []
	starting_weapons = ["pistol"]
	max_deployed = 4
	max_reserve = 3
	max_items = 6
	max_weapons = 4
	active_effects = {}
	death_reason = ""
	run_stats = {
		"total_kills": 0,
		"total_damage_dealt": 0.0,
		"total_damage_taken": 0.0,
		"total_gold_earned": 0,
		"total_xp_earned": 0,
		"total_waves_survived": 0,
		"highest_wave": 0,
		"best_time": 0.0,
		"items_collected": 0,
		"bosses_defeated": 0,
	}

func modify_stat(stat_name: String, amount: float) -> void:
	if player_stats.has(stat_name):
		player_stats[stat_name] += amount

func set_stat(stat_name: String, value: float) -> void:
	player_stats[stat_name] = value

func get_stat(stat_name: String) -> float:
	return player_stats.get(stat_name, 0.0)

func add_currency(amount: int) -> void:
	var bonus: float = amount * (1.0 + player_stats.get("gold_bonus", 0.0))
	currency += int(bonus)
	run_stats["total_gold_earned"] += int(bonus)
	EventBus.currency_changed.emit(currency)
	EventBus.currency_earned.emit(int(bonus))

func spend_currency(amount: int) -> bool:
	if currency >= amount:
		currency -= amount
		EventBus.currency_changed.emit(currency)
		EventBus.currency_spent.emit(amount)
		return true
	return false

func add_effect(effect_name: String, duration: float) -> void:
	active_effects[effect_name] = duration

func remove_effect(effect_name: String) -> void:
	active_effects.erase(effect_name)

func has_effect(effect_name: String) -> bool:
	return active_effects.has(effect_name)

func get_effect_duration(effect_name: String) -> float:
	return active_effects.get(effect_name, 0.0)

func update_effects(delta: float) -> void:
	var expired_effects: Array = []
	for effect_name in active_effects:
		active_effects[effect_name] -= delta
		if active_effects[effect_name] <= 0.0:
			expired_effects.append(effect_name)
	for effect_name in expired_effects:
		active_effects.erase(effect_name)
		EventBus.status_effect_removed.emit(GameManager.get_player(), effect_name)
