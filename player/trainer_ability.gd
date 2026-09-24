extends Node

## TrainerAbility - Handles the player's unique trainer active ability.
## Reads character from DataBus, loads matching ability, manages cooldown and effects.

# --- State ---
var _ability_data: AbilityData = null
var _cooldown_timer: float = 0.0
var _active_duration: float = 0.0
var _is_active: bool = false
var _character_name: String = "Warrior"

# --- Visual ---
var _arc_progress: float = 0.0
var _arc_duration: float = 0.5
var _arc_active: bool = false
var _arc_radius: float = 0.0
var _arc_angle: float = 0.0
var _arc_color: Color = Color.WHITE
var _arc_rotation_speed: float = 0.0

# --- Buff state ---
var _fortify_aura_active: bool = false
var _fortify_aura_progress: float = 0.0
var _fortify_armor_bonus: float = 5.0

# --- Burst visual ---
var _burst_ring_active: bool = false
var _burst_ring_progress: float = 0.0
var _burst_ring_max_duration: float = 0.6
var _burst_ring_radius: float = 0.0
var _burst_color: Color = Color.WHITE
var _parent_player: Node2D = null

var _projectile_scene: PackedScene = preload("res://weapons/projectile/projectile.tscn")

func _ready() -> void:
	_character_name = DataBus.player_stats.get("character_name", "Warrior") as String
	_ability_data = TrainerAbilities.get_ability(_character_name)
	if _ability_data:
		_parent_player = get_player_node()

func _process(delta: float) -> void:
	# Handle cooldown
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta
		if _cooldown_timer <= 0.0:
			_cooldown_timer = 0.0

	# Handle active duration (for buffs like Fortify)
	if _is_active and _active_duration > 0.0:
		_active_duration -= delta
		if _active_duration <= 0.0:
			_deactivate()

	# Handle visual effects
	if _arc_active:
		_arc_progress += delta
		_arc_angle += _arc_rotation_speed * delta
		if _arc_progress >= _arc_duration:
			_arc_active = false

	if _burst_ring_active:
		_burst_ring_progress += delta
		if _burst_ring_progress >= _burst_ring_max_duration:
			_burst_ring_active = false

	if _fortify_aura_active:
		_fortify_aura_progress += delta

func get_player_node() -> Node2D:
	var node: Node = get_parent()
	while node:
		if node.is_in_group("player"):
			return node
		node = node.get_parent()
	return null

func activate() -> bool:
	if not _ability_data:
		printerr("TrainerAbility: No ability data loaded for character '%s'" % _character_name)
		return false

	if _cooldown_timer > 0.0:
		return false

	if _is_active and _active_duration > 0.0:
		return false

	_is_active = true
	_cooldown_timer = _ability_data.cooldown
	_active_duration = _ability_data.duration
	EventBus.ability_used.emit(_ability_data.ability_name)

	match _ability_data.ability_type:
		AbilityData.AbilityType.AOE:
			_activate_aoe()
		AbilityData.AbilityType.PROJECTILE:
			_activate_projectile()
		AbilityData.AbilityType.BUFF:
			_activate_buff()
		AbilityData.AbilityType.BURST:
			_activate_burst()

	return true

func _deactivate() -> void:
	_is_active = false
	_active_duration = 0.0

	# Remove fortify effects
	if _fortify_aura_active:
		_fortify_aura_active = false
		DataBus.remove_effect("fortify")
		if is_instance_valid(_parent_player):
			EventBus.status_effect_removed.emit(_parent_player, "fortify")
		# Remove armor bonus
		DataBus.modify_stat("armor", -_fortify_armor_bonus)

func _activate_aoe() -> void:
	# Warrior Whirlwind
	if not _parent_player:
		return

	var player_pos: Vector2 = _parent_player.global_position
	var radius: float = _ability_data.radius
	var damage: float = DataBus.get_stat("damage") * _ability_data.damage_multiplier

	# Find and damage enemies in radius
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var dist: float = player_pos.distance_to(enemy.global_position)
		if dist <= radius:
			var health_comp = enemy.get_node_or_null("HealthComponent")
			if health_comp and health_comp.has_method("take_damage"):
				var dist_falloff: float = 1.0 - (dist / radius) * 0.3
				var final_damage: float = damage * dist_falloff
				health_comp.take_damage(final_damage, _parent_player)
				EventBus.projectile_hit.emit(enemy, final_damage, enemy.global_position)
				DataBus.run_stats["total_damage_dealt"] += final_damage

	# Spawn arc visual effect
	var nearest: Node2D = _find_nearest_enemy(player_pos)
	_arc_radius = radius
	_arc_color = _ability_data.get_icon_color()
	_arc_rotation_speed = 5.0
	_arc_active = true
	_arc_progress = 0.0
	if nearest:
		_arc_angle = (nearest.global_position - player_pos).angle()
	else:
		_arc_angle = randf() * TAU

	# Spin particles
	for i in 24:
		var angle: float = TAU * float(i) / 24.0
		var dot: ColorRect = ColorRect.new()
		dot.size = Vector2(4, 4)
		dot.color = Color(_arc_color, 0.7)
		var point: Vector2 = player_pos + Vector2(cos(angle), sin(angle)) * radius
		dot.position = point
		get_tree().current_scene.add_child(dot)
		var tween: Tween = dot.create_tween()
		tween.set_parallel(true)
		var arc_target: Vector2 = player_pos + Vector2(cos(angle + 1.0), sin(angle + 1.0)) * (radius * 0.5)
		tween.tween_property(dot, "position", arc_target, 0.4)
		tween.tween_property(dot, "modulate:a", 0.0, 0.4)
		tween.chain().tween_callback(dot.queue_free)

func _activate_projectile() -> void:
	# Ranger Snipe
	if not _parent_player:
		return

	var player_pos: Vector2 = _parent_player.global_position
	var nearest: Node2D = _find_nearest_enemy(player_pos)
	if not nearest or not is_instance_valid(nearest):
		return

	var base_dir: Vector2 = (nearest.global_position - player_pos).normalized()
	var damage: float = DataBus.get_stat("damage") * _ability_data.damage_multiplier
	var cone_spread: float = deg_to_rad(60.0)
	var shot_count: int = 10

	for i in shot_count:
		var t: float = float(i) / float(shot_count - 1)
		var spread: float = lerp(-cone_spread / 2.0, cone_spread / 2.0, t)
		var dir: Vector2 = base_dir.rotated(spread)

		var projectile: Area2D = _projectile_scene.instantiate()
		projectile.global_position = player_pos
		projectile.setup(dir, damage, 800.0, 1, 100.0, _parent_player)
		projectile._lifetime = 2.0
		get_tree().current_scene.add_child(projectile)

	ParticleManager.spawn_floating_text("SNIPE!", player_pos + base_dir * 30.0, Color(0.2, 0.9, 0.2), 16)

func _activate_buff() -> void:
	# Tank Fortify
	if not _parent_player:
		return

	_apply_fortify()

func _apply_fortify() -> void:
	_active_duration = _ability_data.duration
	_fortify_aura_active = true
	_fortify_aura_progress = 0.0

	# Apply armor bonus (+5 armor)
	DataBus.modify_stat("armor", _fortify_armor_bonus)

	# Register as active effect in DataBus
	DataBus.add_effect("fortify", _ability_data.duration)
	EventBus.status_effect_applied.emit(_parent_player, "fortify", _ability_data.duration)

func _activate_burst() -> void:
	# Mage Elemental Blast
	if not _parent_player:
		return

	var player_pos: Vector2 = _parent_player.global_position
	var radius: float = _ability_data.radius
	var base_damage: float = DataBus.get_stat("damage") * _ability_data.damage_multiplier

	# Get first companion element type
	var companion_element: CompanionData.CompanionType = CompanionData.CompanionType.GRASS
	var player_node: Node2D = _parent_player
	if player_node:
		for child in player_node.get_children():
			if child.has_method("set_companion_data") and child.get("companion_data"):
				var comp_data: CompanionData = child.companion_data
				if comp_data:
					companion_element = comp_data.companion_type
					break

	# Determine damage type and color from element
	var element_damage: float = 0.0
	match companion_element:
		CompanionData.CompanionType.FIRE:
			_burst_color = Color(0.91, 0.3, 0.24)
			element_damage = base_damage * 1.2
		CompanionData.CompanionType.WATER:
			_burst_color = Color(0.2, 0.6, 0.86)
			element_damage = base_damage
		CompanionData.CompanionType.GRASS:
			_burst_color = Color(0.18, 0.8, 0.44)
			element_damage = base_damage * 0.8
	element_damage += DataBus.get_stat("elemental_damage")

	# Damage enemies in radius
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if not is_instance_valid(enemy):
			continue
		var dist: float = player_pos.distance_to(enemy.global_position)
		if dist <= radius:
			var health_comp = enemy.get_node_or_null("HealthComponent")
			if health_comp and health_comp.has_method("take_damage"):
				var final_damage: float = element_damage
				health_comp.take_damage(final_damage, _parent_player)
				EventBus.projectile_hit.emit(enemy, final_damage, enemy.global_position)
				DataBus.run_stats["total_damage_dealt"] += final_damage
				_apply_elemental_effect(enemy, companion_element)

	# Burst ring visual
	_burst_ring_active = true
	_burst_ring_progress = 0.0
	_burst_ring_radius = radius
	_burst_color = _burst_color

	# Spawn ring particles
	for i in 16:
		var angle: float = TAU * float(i) / 16.0
		var p: ColorRect = ColorRect.new()
		p.size = Vector2(6, 6)
		p.color = Color(_burst_color, 0.8)
		p.position = player_pos + Vector2(cos(angle), sin(angle)) * radius
		get_tree().current_scene.add_child(p)
		var tween: Tween = p.create_tween()
		tween.set_parallel(true)
		tween.tween_property(p, "modulate:a", 0.0, 0.5)
		tween.tween_property(p, "scale", Vector2(0.1, 0.1), 0.5)
		tween.chain().tween_callback(p.queue_free)

func _apply_elemental_effect(target: Node, element: CompanionData.CompanionType) -> void:
	match element:
		CompanionData.CompanionType.FIRE:
			_apply_dot(target, 5.0, 3.0)
		CompanionData.CompanionType.WATER:
			_ice_slow(target)
		CompanionData.CompanionType.GRASS:
			_apply_dot(target, 3.0, 4.0)

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
				hc.take_damage(damage, _parent_player)
		)

func _ice_slow(target: Node) -> void:
	if target.get("movement"):
		var original_speed: float = target.get("movement").speed
		target.get("movement").speed *= 0.4
		var timer: Timer = Timer.new()
		timer.wait_time = 3.0
		timer.one_shot = true
		target.add_child(timer)
		timer.start()
		timer.timeout.connect(func() -> void:
			if is_instance_valid(target) and target.get("movement"):
				target.get("movement").speed = original_speed
			timer.queue_free()
		)

func _find_nearest_enemy(from_pos: Vector2) -> Node2D:
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_dist: float = INF
	for e in enemies:
		if not is_instance_valid(e):
			continue
		var dist: float = from_pos.distance_to(e.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = e
	return nearest

func is_on_cooldown() -> bool:
	return _cooldown_timer > 0.0

func get_cooldown_remaining() -> float:
	return _cooldown_timer

func get_cooldown_total() -> float:
	return _ability_data.cooldown if _ability_data else 0.0

func get_effectiveness() -> float:
	if not _ability_data or _ability_data.cooldown <= 0.0:
		return 0.0
	if _cooldown_timer <= 0.0:
		return 1.0
	return 1.0 - (_cooldown_timer / _ability_data.cooldown)
