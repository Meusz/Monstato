extends Node

## CurrencyManager - Spawns coin pickups on enemy kills.
## Handles wave-end coin collection with harvesting %.

var _coin_scene: PackedScene = preload("res://economy/coin_pickup.tscn")
var _active_coins: Array[Area2D] = []

func _ready() -> void:
	EventBus.enemy_killed.connect(_on_enemy_killed)

func _on_enemy_killed(enemy: Node, _xp_value: int) -> void:
	var coin_count: int = randi_range(1, 3)
	for i in coin_count:
		_spawn_coin(enemy.global_position)

func _spawn_coin(pos: Vector2) -> void:
	var coin: Area2D = _coin_scene.instantiate()
	var offset := Vector2(randf_range(-12, 12), randf_range(-12, 12))
	coin.setup(pos + offset, 1)
	add_child(coin)
	_active_coins.append(coin)

func collect_all_coins() -> void:
	for coin in _active_coins:
		if is_instance_valid(coin) and not coin._collected:
			coin.start_flying()

func get_active_coin_count() -> int:
	var count: int = 0
	for coin in _active_coins:
		if is_instance_valid(coin) and not coin._collected:
			count += 1
	return count

func kill_all_enemies() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if is_instance_valid(e) and e.has_node("HealthComponent"):
			var hc: HealthComponent = e.get_node("HealthComponent")
			hc.current_health = 0.0
			hc.died.emit()

func _on_enemy_killed_remove(enemy: Node) -> void:
	_active_coins = _active_coins.filter(func(c: Area2D) -> bool: return is_instance_valid(c))
