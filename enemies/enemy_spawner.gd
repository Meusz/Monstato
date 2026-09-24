extends Node

## EnemySpawner - Spawns enemies continuously during waves with spawn indicators.

var _enemy_scene: PackedScene
var _parent: Node2D
var _spawn_timer: float = 0.0
var _spawning: bool = false
var _active_enemies: Array[Node2D] = []
var _current_enemy_keys: Array = []
var _total_to_spawn: int = 0
var _spawned_count: int = 0

@export var spawn_rate: float = 1.0
@export var max_enemies: int = 100
@export var spawn_indicator_duration: float = 1.5

func _ready() -> void:
	_enemy_scene = preload("res://enemies/enemy_base.tscn")

func initialize(parent: Node2D) -> void:
	_parent = parent

func _process(delta: float) -> void:
	if _spawning:
		_spawn_timer -= delta
		if _spawn_timer <= 0.0:
			_show_spawn_indicator()
			_spawn_timer = spawn_rate

func start_spawning(count: int, rate: float, enemy_keys: Array) -> void:
	_spawning = true
	spawn_rate = rate
	_spawn_timer = 0.0
	_current_enemy_keys = enemy_keys
	_total_to_spawn = count
	_spawned_count = 0

func stop_spawning() -> void:
	_spawning = false

func _show_spawn_indicator() -> void:
	var arena_size: Vector2 = Vector2(1200, 900)
	var margin: float = 50.0
	var pos: Vector2 = Vector2(randf_range(margin, arena_size.x - margin), randf_range(margin, arena_size.y - margin))
	_create_indicator(pos)

func _create_indicator(pos: Vector2) -> void:
	var indicator := ColorRect.new()
	indicator.size = Vector2(40, 40)
	indicator.position = pos - Vector2(20, 20)
	indicator.color = Color(1.0, 0.2, 0.2, 0.3)
	get_tree().current_scene.add_child(indicator)
	var tween := indicator.create_tween()
	tween.tween_property(indicator, "modulate:a", 0.0, spawn_indicator_duration)
	tween.chain().tween_callback(indicator.queue_free)
	get_tree().create_timer(spawn_indicator_duration).timeout.connect(_spawn_at_position.bind(pos))

func _spawn_at_position(pos: Vector2) -> void:
	if not _parent:
		return
	if _active_enemies.size() >= max_enemies:
		return
	var enemy: CharacterBody2D = _enemy_scene.instantiate() as CharacterBody2D
	if not enemy:
		return
	_spawned_count += 1
	enemy.global_position = pos
	_parent.add_child(enemy)
	_active_enemies.append(enemy)
	enemy.tree_exited.connect(_on_enemy_removed.bind(enemy))
	_assign_enemy_data(enemy)
	EventBus.enemy_spawned.emit(enemy)

func _assign_enemy_data(enemy: Node) -> void:
	if _current_enemy_keys.is_empty():
		return
	var key: String = _current_enemy_keys[randi() % _current_enemy_keys.size()]
	var data: EnemyData = EnemyDatabase.get_enemy(key)
	if data and enemy.has_method("set_data"):
		enemy.set_data(data)

func _on_enemy_removed(enemy: Node2D) -> void:
	_active_enemies.erase(enemy)

func get_enemies() -> Array[Node2D]:
	return _active_enemies

func clear_all() -> void:
	for enemy in _active_enemies:
		if is_instance_valid(enemy):
			enemy.queue_free()
	_active_enemies.clear()

func get_remaining_count() -> int:
	return maxf(0, _total_to_spawn - _spawned_count)

func get_active_count() -> int:
	return _active_enemies.size()
