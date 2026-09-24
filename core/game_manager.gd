extends Node

## GameManager - Controls the overall game state and flow.
## Central orchestrator that coordinates between all systems.

enum GameState {
	MAIN_MENU,
	CHARACTER_SELECT,
	WAVE_PREP,
	WAVE_ACTIVE,
	WAVE_COMPLETE,
	SHOP,
	PAUSED,
	GAME_OVER,
	VICTORY,
}

var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU
var current_scene_path: String = ""
var run_timer: float = 0.0
var is_paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.scene_change_requested.connect(_on_scene_change_requested)
	EventBus.game_paused.connect(_on_game_paused)
	EventBus.shop_closed.connect(_on_shop_closed)

func _process(delta: float) -> void:
	if current_state == GameState.WAVE_ACTIVE:
		run_timer += delta

func change_state(new_state: GameState) -> void:
	if new_state == current_state:
		return
	previous_state = current_state
	current_state = new_state
	_handle_state_transition(new_state)

func _handle_state_transition(state: GameState) -> void:
	if state != GameState.PAUSED and is_paused:
		get_tree().paused = false
		is_paused = false
		EventBus.game_paused.emit(false)
	match state:
		GameState.MAIN_MENU:
			get_tree().paused = false
			is_paused = false
			EventBus.game_paused.emit(false)
		GameState.CHARACTER_SELECT:
			pass
		GameState.WAVE_PREP:
			pass
		GameState.WAVE_ACTIVE:
			EventBus.wave_started.emit(DataBus.current_wave)
		GameState.WAVE_COMPLETE:
			DataBus.run_stats["total_waves_survived"] += 1
			if DataBus.current_wave > DataBus.run_stats["highest_wave"]:
				DataBus.run_stats["highest_wave"] = DataBus.current_wave
			EventBus.wave_completed.emit(DataBus.current_wave)
			_open_shop()
		GameState.SHOP:
			EventBus.shop_opened.emit()
		GameState.PAUSED:
			get_tree().paused = true
			is_paused = true
			EventBus.game_paused.emit(true)
		GameState.GAME_OVER:
			EventBus.game_over.emit(false)
		GameState.VICTORY:
			EventBus.game_over.emit(true)

func _open_shop() -> void:
	change_state(GameState.SHOP)

func _on_shop_closed() -> void:
	if previous_state == GameState.WAVE_COMPLETE or current_state == GameState.SHOP:
		change_state(GameState.WAVE_PREP)

func start_new_run() -> void:
	DataBus.reset_runtime_data()
	run_timer = 0.0
	change_state(GameState.WAVE_PREP)
	EventBus.game_started.emit()

func toggle_pause() -> void:
	if is_paused:
		change_state(previous_state)
	elif current_state in [GameState.WAVE_ACTIVE, GameState.WAVE_PREP, GameState.SHOP]:
		change_state(GameState.PAUSED)

func get_player() -> Node:
	var player: Node = get_tree().get_first_node_in_group("player")
	return player

func get_active_enemies() -> Array[Node]:
	return get_tree().get_nodes_in_group("enemies")

func get_enemy_count() -> int:
	return get_active_enemies().size()

func _on_scene_change_requested(scene_path: String) -> void:
	current_scene_path = scene_path
	get_tree().call_deferred("change_scene_to_file", scene_path)

func _on_game_paused(paused: bool) -> void:
	if paused:
		change_state(GameState.PAUSED)
	elif is_paused and current_state == GameState.PAUSED:
		change_state(previous_state)

func get_run_time_formatted() -> String:
	var minutes := int(run_timer) / 60
	var seconds := int(run_timer) % 60
	return "%02d:%02d" % [minutes, seconds]

func get_run_time() -> float:
	return run_timer
