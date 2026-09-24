extends Node2D

## CompanionNode - Moves around player and auto-attacks enemies.
## Melee: walks toward enemy, area attack with arc visual.
## Ranged: stays near owner and shoots projectiles.
## Only fights when deployed. Stats boosted by player stats.
## Applies passive bonuses, element effects, and type multiplier.

var companion_data: CompanionData
var deployed: bool = true
var _owner: Node2D
var _cooldown_timer: float = 0.0
var _sprite: Sprite2D
var _nearest_enemy: Node2D = null
var _nearest_dist: float = INF
var _wander_offset: Vector2 = Vector2.ZERO
var _wander_timer: float = 0.0
var _wander_interval: float = 1.5
var _max_distance: float = 120.0
var _move_speed: float = 150.0

var _arc_active: bool = false
var _arc_angle: float = 0.0
var _arc_progress: float = 0.0
var _arc_duration: float = 0.2
var _arc_radius: float = 40.0
var _arc_color: Color = Color.WHITE

var wave_damage_dealt: float = 0.0
var _bonuses_applied: bool = false

func _ready() -> void:
	_sprite = Sprite2D.new()
	_sprite.scale = Vector2(0.8, 0.8)
	add_child(_sprite)
	_owner = _find_owner()
	_pick_new_wander()
	EventBus.enemy_killed.connect(_on_enemy_killed)

func _exit_tree() -> void:
	if EventBus.enemy_killed.is_connected(_on_enemy_killed):
		EventBus.enemy_killed.disconnect(_on_enemy_killed)
	_remove_passive_bonuses()

func _process(delta: float) -> void:
	if not companion_data or not _owner:
		return
	if not deployed:
		visible = false
		if _bonuses_applied:
			_remove_passive_bonuses()
		return
	visible = true
	if not _bonuses_applied:
		_apply_passive_bonuses()
	_find_nearest_enemy()
	if companion_data.combat_type == CompanionData.CombatType.MELEE:
		_process_melee(delta)
	else:
		_process_ranged(delta)
	_cooldown_timer -= delta
	if _arc_active:
		_arc_progress += delta
		if _arc_progress >= _arc_duration:
			_arc_active = false
	queue_redraw()

func _apply_passive_bonuses() -> void:
	if not companion_data:
		return
	_bonuses_applied = true
	if companion_data.player_xp_bonus > 0:
		DataBus.modify_stat("xp_bonus", companion_data.player_xp_bonus)
	if companion_data.player_shield > 0:
		DataBus.modify_stat("armor", companion_data.player_shield)
	if companion_data.player_life_steal > 0:
		DataBus.modify_stat("life_steal", companion_data.player_life_steal)
	if companion_data.player_damage_bonus > 0:
		DataBus.modify_stat("damage", companion_data.player_damage_bonus)
	if companion_data.player_speed_bonus > 0:
		DataBus.modify_stat("speed", companion_data.player_speed_bonus)

func _remove_passive_bonuses() -> void:
	if not companion_data or not _bonuses_applied:
		return
	_bonuses_applied = false
	if companion_data.player_xp_bonus > 0:
		DataBus.modify_stat("xp_bonus", -companion_data.player_xp_bonus)
	if companion_data.player_shield > 0:
		DataBus.modify_stat("armor", -companion_data.player_shield)
	if companion_data.player_life_steal > 0:
		DataBus.modify_stat("life_steal", -companion_data.player_life_steal)
	if companion_data.player_damage_bonus > 0:
		DataBus.modify_stat("damage", -companion_data.player_damage_bonus)
	if companion_data.player_speed_bonus > 0:
		DataBus.modify_stat("speed", -companion_data.player_speed_bonus)

func _get_stat_bonus() -> float:
	var s: Dictionary = DataBus.player_stats
	return 1.0 + s.get("damage", 0.0) / 100.0

func _get_speed_bonus() -> float:
	var s: Dictionary = DataBus.player_stats
	return 1.0 + s.get("attack_speed", 0.0) / 100.0

func _get_range_bonus() -> float:
	var s: Dictionary = DataBus.player_stats
	return 1.0 + s.get("range", 0.0) / 100.0

func _get_type_multiplier(target: Node) -> float:
	if not companion_data:
		return 1.0
	var enemy_data: Resource = target.get("enemy_data") if target.get("enemy_data") != null else null
	if enemy_data and enemy_data.get("element") != null:
		var enemy_element: CompanionData.CompanionType = enemy_data.element
		return companion_data.get_type_multiplier(enemy_element)
	return 1.0

func _apply_element_effect(target: Node) -> void:
	if not companion_data or companion_data.element_effect == CompanionData.ElementEffect.NONE:
		return
	if randf() * 100.0 > companion_data.effect_chance:
		return
	if not is_instance_valid(target):
		return
	match companion_data.element_effect:
		CompanionData.ElementEffect.BURN, CompanionData.ElementEffect.POISON, CompanionData.ElementEffect.BLEED:
			_apply_dot(target, companion_data.effect_damage, companion_data.effect_duration)
		CompanionData.ElementEffect.FREEZE:
			if target.get("movement"):
				var original_speed: float = target.movement.speed
				target.movement.speed *= 0.3
				var timer := Timer.new()
				timer.wait_time = companion_data.effect_duration
				timer.one_shot = true
				target.add_child(timer)
				timer.start()
				timer.timeout.connect(func() -> void:
					if is_instance_valid(target) and target.get("movement"):
						target.movement.speed = original_speed
					if is_instance_valid(timer):
						timer.queue_free()
				)

func _apply_dot(target: Node, damage: float, duration: float) -> void:
	var tick_interval: float = 1.0
	var ticks: int = int(duration / tick_interval)
	if ticks <= 0:
		ticks = 1
	for i in range(ticks):
		var delay: float = (i + 1) * tick_interval
		get_tree().create_timer(delay).timeout.connect(func() -> void:
			if is_instance_valid(target) and target.has_node("HealthComponent"):
				var hc: HealthComponent = target.get_node("HealthComponent")
				hc.take_damage(damage, _owner)
				wave_damage_dealt += damage
		)

func _process_melee(delta: float) -> void:
	var melee_range: float = companion_data.attack_range * _get_range_bonus()
	if _nearest_enemy and is_instance_valid(_nearest_enemy):
		var dist_to_enemy: float = global_position.distance_to(_nearest_enemy.global_position)
		if dist_to_enemy <= melee_range:
			if _cooldown_timer <= 0.0:
				_melee_attack()
				_cooldown_timer = 1.0 / (companion_data.attack_speed * _get_speed_bonus())
			return
		elif dist_to_enemy <= melee_range * 3.0:
			var dir: Vector2 = (_nearest_enemy.global_position - global_position).normalized()
			global_position += dir * _move_speed * 1.2 * delta
			_clamp_to_owner()
			return
	_wander(delta)
	_clamp_to_owner()

func _process_ranged(delta: float) -> void:
	_wander(delta)
	_clamp_to_owner()
	if _nearest_enemy and is_instance_valid(_nearest_enemy):
		var shoot_range: float = companion_data.attack_range * 2.5 * _get_range_bonus()
		var dist_to_enemy: float = global_position.distance_to(_nearest_enemy.global_position)
		if dist_to_enemy <= shoot_range and _cooldown_timer <= 0.0:
			_ranged_attack()
			_cooldown_timer = 1.0 / (companion_data.attack_speed * _get_speed_bonus())

func _wander(delta: float) -> void:
	_wander_timer -= delta
	if _wander_timer <= 0.0:
		_pick_new_wander()
	var target_pos: Vector2 = _owner.global_position + _wander_offset
	var dir: Vector2 = (target_pos - global_position)
	if dir.length() > 5.0:
		global_position += dir.normalized() * _move_speed * delta

func _clamp_to_owner() -> void:
	var dist: float = global_position.distance_to(_owner.global_position)
	if dist > _max_distance:
		global_position = _owner.global_position + (global_position - _owner.global_position).normalized() * _max_distance

func _pick_new_wander() -> void:
	_wander_timer = _wander_interval + randf_range(-0.5, 0.5)
	var angle: float = randf() * TAU
	var dist: float = randf_range(30.0, _max_distance)
	_wander_offset = Vector2(cos(angle), sin(angle)) * dist

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

func _melee_attack() -> void:
	if not _nearest_enemy or not is_instance_valid(_nearest_enemy):
		return
	var type_mult: float = _get_type_multiplier(_nearest_enemy)
	var base_dmg: float = companion_data.base_damage * _get_stat_bonus() * type_mult
	var is_crit: bool = randf() < DataBus.player_stats.get("crit_chance", 0.05)
	var dmg: float = base_dmg * DataBus.player_stats.get("crit_multiplier", 2.0) if is_crit else base_dmg
	_arc_angle = global_position.direction_to(_nearest_enemy.global_position).angle()
	_arc_radius = companion_data.attack_range * 1.5 * _get_range_bonus()
	_arc_color = companion_data.get_type_color()
	_arc_active = true
	_arc_progress = 0.0
	var hit_enemies: Array[Node2D] = []
	for e in get_tree().get_nodes_in_group("enemies"):
		if not is_instance_valid(e):
			continue
		var dist: float = global_position.distance_to(e.global_position)
		if dist <= _arc_radius:
			hit_enemies.append(e)
	for e in hit_enemies:
		var hit_mult: float = _get_type_multiplier(e)
		var health_comp = e.get_node_or_null("HealthComponent")
		if health_comp and health_comp.has_method("take_damage"):
			var dist: float = global_position.distance_to(e.global_position)
			var falloff: float = 1.0 - (dist / _arc_radius) * 0.5
			var final_dmg: float = dmg * falloff * hit_mult
			health_comp.take_damage(final_dmg, _owner)
			wave_damage_dealt += final_dmg
			if is_crit:
				EventBus.critical_hit.emit(e, final_dmg)
		_apply_element_effect(e)
		EventBus.projectile_hit.emit(e, dmg, e.global_position)
	_flash_hit()

func _ranged_attack() -> void:
	if not _nearest_enemy or not is_instance_valid(_nearest_enemy):
		return
	var direction: Vector2 = (_nearest_enemy.global_position - global_position).normalized()
	var type_mult: float = _get_type_multiplier(_nearest_enemy)
	var base_dmg: float = companion_data.base_damage * _get_stat_bonus() * type_mult
	var is_crit: bool = randf() < DataBus.player_stats.get("crit_chance", 0.05)
	var dmg: float = base_dmg * DataBus.player_stats.get("crit_multiplier", 2.0) if is_crit else base_dmg
	_spawn_projectile(direction, dmg, is_crit)
	_flash_hit()

func _flash_hit() -> void:
	if not _sprite:
		return
	var original_color: Color = _sprite.modulate
	_sprite.modulate = Color(3.0, 3.0, 3.0, 1.0)
	var tween := create_tween()
	tween.tween_property(_sprite, "modulate", original_color, 0.12)

func _spawn_projectile(direction: Vector2, dmg: float, is_crit: bool = false) -> void:
	var projectile_scene := preload("res://weapons/projectile/projectile.tscn")
	var projectile := projectile_scene.instantiate()
	projectile.global_position = global_position
	projectile.setup(direction, dmg, companion_data.projectile_speed, 0, companion_data.knockback, _owner, self)
	projectile._is_critical = is_crit
	get_tree().current_scene.add_child(projectile)

func set_companion_data(data: CompanionData) -> void:
	if companion_data and _bonuses_applied:
		_remove_passive_bonuses()
	companion_data = data
	_max_distance = data.orbit_distance * 3.0
	_move_speed = data.orbit_speed * 40.0
	_update_sprite()

func reset_wave_damage() -> void:
	wave_damage_dealt = 0.0

func get_damage_log_entry() -> Dictionary:
	return {
		"name": companion_data.companion_name if companion_data else "Unknown",
		"key": companion_data.companion_key if companion_data else "",
		"phase": companion_data.phase if companion_data else 1,
		"level": companion_data.level if companion_data else 1,
		"type_color": companion_data.get_type_color() if companion_data else Color.WHITE,
		"damage": int(wave_damage_dealt),
	}

func _update_sprite() -> void:
	if not companion_data:
		return
	match companion_data.companion_key:
		"slime": _sprite.texture = SpriteGenerator.companion_slime()
		"spider": _sprite.texture = SpriteGenerator.companion_poison_spider()
		"stone_golem": _sprite.texture = SpriteGenerator.companion_stone_golem()
		"lightning_bug": _sprite.texture = SpriteGenerator.companion_lightning_bug()
		"fire_spirit": _sprite.texture = SpriteGenerator.companion_fire_spirit()
		"phoenix": _sprite.texture = SpriteGenerator.companion_phoenix()
		"skeleton": _sprite.texture = SpriteGenerator.companion_skeleton()
		"ice_crystal": _sprite.texture = SpriteGenerator.companion_ice_crystal()
		"shadow_cat": _sprite.texture = SpriteGenerator.companion_shadow_cat()
		"bat": _sprite.texture = SpriteGenerator.companion_bat()
		_: _sprite.texture = SpriteGenerator.companion_slime()
	_sprite.modulate = companion_data.get_type_color()

func _find_owner() -> Node2D:
	var node := get_parent()
	while node:
		if node.is_in_group("player"):
			return node
		node = node.get_parent()
	return get_parent()

func _draw() -> void:
	if not companion_data:
		return
	if not deployed:
		return
	var type_col: Color = companion_data.get_type_color()
	draw_circle(Vector2.ZERO, 4.0, Color(type_col, 0.3))
	if _arc_active:
		var t: float = _arc_progress / _arc_duration
		var alpha: float = (1.0 - t) * 0.45
		var arc_span: float = deg_to_rad(120.0)
		var current_radius: float = _arc_radius * (0.3 + t * 0.7)
		var points: PackedVector2Array = PackedVector2Array()
		points.append(Vector2.ZERO)
		var segments: int = 16
		for i in segments + 1:
			var a: float = _arc_angle - arc_span / 2.0 + arc_span * float(i) / float(segments)
			points.append(Vector2(cos(a), sin(a)) * current_radius)
		var col: Color = Color(_arc_color.r, _arc_color.g, _arc_color.b, alpha)
		draw_colored_polygon(points, col)
		var edge_col: Color = Color(_arc_color.r, _arc_color.g, _arc_color.b, alpha * 1.5)
		for i in segments:
			var a1: float = _arc_angle - arc_span / 2.0 + arc_span * float(i) / float(segments)
			var a2: float = _arc_angle - arc_span / 2.0 + arc_span * float(i + 1) / float(segments)
			draw_line(Vector2(cos(a1), sin(a1)) * current_radius, Vector2(cos(a2), sin(a2)) * current_radius, edge_col, 1.5)

func _on_enemy_killed(_enemy: Node, xp_value: int) -> void:
	if not companion_data:
		return
	var leveled: bool = companion_data.add_xp(xp_value)
	if leveled:
		EventBus.companion_leveled_up.emit(companion_data.companion_name, companion_data.level)
