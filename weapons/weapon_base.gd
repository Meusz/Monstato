extends Node2D

## WeaponBase - Auto-shoots only when enemy is in range.

@export var weapon_data: WeaponData
var _cooldown_timer: float = 0.0
var _owner: Node2D
var _nearest_enemy: Node2D = null
var _nearest_dist: float = INF

func _ready() -> void:
	_owner = _find_owner()
	if not weapon_data:
		weapon_data = WeaponData.new()

func _process(_delta: float) -> void:
	_find_nearest_enemy()
	queue_redraw()

func _find_nearest_enemy() -> void:
	_nearest_enemy = null
	_nearest_dist = INF
	var enemies := get_tree().get_nodes_in_group("enemies")
	for e in enemies:
		if not is_instance_valid(e):
			continue
		var dist: float = global_position.distance_to(e.global_position)
		if dist < _nearest_dist:
			_nearest_dist = dist
			_nearest_enemy = e

func _draw() -> void:
	if not weapon_data:
		return
	var dir: Vector2 = _get_attack_direction()
	var angle: float = dir.angle()
	draw_set_transform(Vector2.ZERO, angle, Vector2.ONE)
	draw_rect(Rect2(Vector2(0, -2), Vector2(14, 4)), Color.html("#7f8c8d"))
	draw_rect(Rect2(Vector2(10, -3), Vector2(6, 6)), Color.html("#5d6d7e"))
	draw_set_transform(Vector2.ZERO, 0, Vector2.ONE)

func _find_owner() -> Node2D:
	var node := get_parent()
	while node:
		if node.is_in_group("player"):
			return node
		node = node.get_parent()
	return get_parent()

func update_cooldown(delta: float) -> void:
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta

func has_target_in_range() -> bool:
	if not _nearest_enemy or not is_instance_valid(_nearest_enemy):
		return false
	var stats: Dictionary = _get_owner_stats()
	var range_bonus: float = float(stats.get("range", 0.0))
	var effective_range: float = weapon_data.attack_range * (1.0 + range_bonus / 100.0)
	return _nearest_dist <= effective_range

func can_attack() -> bool:
	return _cooldown_timer <= 0.0 and has_target_in_range()

func attack() -> void:
	if not can_attack():
		return
	_cooldown_timer = 1.0 / weapon_data.attack_speed
	_fire_projectiles()
	EventBus.weapon_fired.emit(self, weapon_data.projectile_count)

func _fire_projectiles() -> void:
	var owner_stats: Dictionary = _get_owner_stats()
	var direction: Vector2 = _get_attack_direction()
	var base_damage: float = weapon_data.base_damage * (1.0 + float(owner_stats.get("damage", 0.0)) / 100.0)
	var is_crit: bool = randf() < float(owner_stats.get("crit_chance", 0.05))
	var damage: float = base_damage * float(owner_stats.get("crit_multiplier", 2.0)) if is_crit else base_damage
	if is_crit:
		EventBus.critical_hit.emit(_owner, damage)
	var projectile_count := weapon_data.projectile_count + int(owner_stats.get("projectile_count", 0)) - 1
	var total_count := maxi(projectile_count, 1)
	var start_angle: float = direction.angle()
	var spread_angle: float = deg_to_rad(weapon_data.spread)
	for i in total_count:
		var angle_offset := 0.0
		if total_count > 1:
			angle_offset = lerp(-spread_angle / 2.0, spread_angle / 2.0, float(i) / float(total_count - 1))
		var proj_direction := Vector2.from_angle(start_angle + angle_offset)
		_spawn_projectile(proj_direction, damage)

func _spawn_projectile(direction: Vector2, damage: float) -> void:
	var projectile_scene := preload("res://weapons/projectile/projectile.tscn")
	var projectile := projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.setup(direction, damage, weapon_data.projectile_speed, weapon_data.projectile_pierce, weapon_data.knockback, _owner)
	get_tree().current_scene.add_child(projectile)

func _get_attack_direction() -> Vector2:
	if _nearest_enemy and is_instance_valid(_nearest_enemy):
		return (_nearest_enemy.global_position - global_position).normalized()
	return Vector2.RIGHT

func _get_owner_stats() -> Dictionary:
	if _owner and _owner.has_node("PlayerStats"):
		return _owner.get_node("PlayerStats").get_stats()
	return DataBus.player_stats

func set_weapon_data(data: WeaponData) -> void:
	weapon_data = data
