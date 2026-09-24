extends Node

## WaveManager - Controls wave progression and timing.
## Kill streak increases spawn rate. Wave-end kills don't count.

var _current_wave: int = 0
var _wave_timer: float = 0.0
var _is_wave_active: bool = false
var _ending_wave: bool = false
var _spawner: Node
var _total_enemies: int = 0
var _enemies_spawned: int = 0
var _kill_streak: int = 0
var _kill_streak_timer: float = 0.0
var _kill_streak_decay: float = 3.0
var _base_spawn_rate: float = 1.0

func _ready() -> void:
	EventBus.wave_started.connect(_on_wave_started)
	EventBus.enemy_killed.connect(_on_enemy_killed)

func initialize(spawner: Node) -> void:
	_spawner = spawner

func _process(delta: float) -> void:
	if _is_wave_active:
		_wave_timer -= delta
		EventBus.wave_timer_updated.emit(_wave_timer)
		if _wave_timer <= 0.0:
			_end_wave()
		if _kill_streak_timer > 0.0:
			_kill_streak_timer -= delta
			if _kill_streak_timer <= 0.0:
				_kill_streak = 0
				_update_spawn_rate()

func start_next_wave() -> void:
	_current_wave += 1
	DataBus.current_wave = _current_wave
	_total_enemies = 0
	_enemies_spawned = 0
	_kill_streak = 0
	_kill_streak_timer = 0.0
	GameManager.change_state(GameManager.GameState.WAVE_ACTIVE)

func _on_wave_started(wave_number: int) -> void:
	_is_wave_active = true
	_ending_wave = false
	_wave_timer = _calculate_wave_duration(wave_number)
	var enemy_count := _calculate_enemy_count(wave_number)
	_total_enemies = enemy_count
	var enemy_keys := _get_wave_enemy_keys(wave_number)
	_base_spawn_rate = 1.0 / (1.0 + (wave_number - 1) * 0.4)
	if _spawner:
		_spawner.start_spawning(enemy_count, _base_spawn_rate, enemy_keys)

func _end_wave() -> void:
	if not _is_wave_active or _ending_wave:
		return
	_ending_wave = true
	_is_wave_active = false
	if _spawner:
		_spawner.stop_spawning()
	var currency_mgr := get_node_or_null("/root/CurrencyManager")
	if currency_mgr:
		currency_mgr.kill_all_enemies()
		await get_tree().create_timer(0.5).timeout
		currency_mgr.collect_all_coins()
		while currency_mgr.get_active_coin_count() > 0:
			await get_tree().create_timer(0.1).timeout
	if _spawner:
		_spawner.clear_all()
	var max_hp: float = DataBus.player_stats.get("max_health", 100.0)
	DataBus.player_stats["health"] = max_hp
	EventBus.player_healed.emit(max_hp)
	var player := GameManager.get_player()
	if player and player.has_node("HealthComponent"):
		player.get_node("HealthComponent").reset_health()
	_ending_wave = false
	GameManager.change_state(GameManager.GameState.WAVE_COMPLETE)

func _on_enemy_killed(_enemy: Node, _xp: int) -> void:
	if not _is_wave_active or _ending_wave:
		return
	DataBus.total_enemies_killed += 1
	DataBus.run_stats["total_kills"] += 1
	_kill_streak += 1
	_kill_streak_timer = _kill_streak_decay
	_update_spawn_rate()
	var alive := GameManager.get_enemy_count()
	if alive <= 0 and _spawner and _spawner.get_remaining_count() <= 0:
		_end_wave()

func _update_spawn_rate() -> void:
	if not _spawner:
		return
	var streak_bonus: float = clampf(_kill_streak * 0.03, 0.0, 0.5)
	_spawner.spawn_rate = maxf(_base_spawn_rate * (1.0 - streak_bonus), 0.2)

func _calculate_wave_duration(wave: int) -> float:
	return 30.0

func _calculate_enemy_count(wave: int) -> int:
	return 10 + (wave - 1) * 5

func _get_wave_enemy_keys(wave: int) -> Array:
	var keys: Array = ["melee"]
	if wave >= 2:
		keys.append("fast")
	if wave >= 3:
		keys.append("ranged")
	if wave >= 5:
		keys.append("tank")
	if wave >= 8:
		keys.append("mini_boss")
	if wave >= 10:
		keys.append("boss")
	return keys

func get_current_wave() -> int:
	return _current_wave

func get_time_remaining() -> float:
	return _wave_timer

func is_wave_active() -> bool:
	return _is_wave_active
