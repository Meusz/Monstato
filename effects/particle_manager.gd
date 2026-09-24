extends Node

## ParticleManager - Manages particle effects for combat feedback.

var _damage_number_scene: PackedScene = preload("res://effects/damage_numbers/damage_number.tscn")

func _ready() -> void:
	EventBus.projectile_hit.connect(_on_projectile_hit)
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.critical_hit.connect(_on_critical_hit)
	EventBus.companion_leveled_up.connect(_on_companion_leveled_up)
	EventBus.player_healed.connect(_on_player_healed)
	EventBus.player_dodged.connect(_on_player_dodged)

func _on_projectile_hit(_target: Node, damage: float, pos: Vector2) -> void:
	spawn_damage_number(damage, pos, false)
	spawn_hit_effect(pos)

func _on_enemy_killed(enemy: Node, _xp: int) -> void:
	if enemy is Node2D:
		spawn_death_effect(enemy.global_position)

func _on_critical_hit(target: Node, amount: float) -> void:
	if target is Node2D:
		spawn_floating_text(str(int(amount)), target.global_position + Vector2(0, -20), Color(1.0, 0.9, 0.1), 20)

func _on_companion_leveled_up(companion_name: String, _new_level: int) -> void:
	var player := GameManager.get_player()
	if not player:
		return
	for child in player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			if child.companion_data.companion_name == companion_name:
				spawn_floating_text("LVL UP!", child.global_position + Vector2(0, -15), Color(0.2, 1.0, 0.3), 14)
				return

func _on_player_healed(amount: float) -> void:
	var player := GameManager.get_player()
	if player:
		spawn_floating_text("+%d" % int(amount), player.global_position + Vector2(0, -20), Color(0.2, 1.0, 0.3), 14)

func _on_player_dodged() -> void:
	var player := GameManager.get_player()
	if player:
		spawn_floating_text("DODGE!", player.global_position + Vector2(0, -20), Color.WHITE, 14)

func spawn_floating_text(text: String, pos: Vector2, color: Color, font_size: int = 16) -> void:
	var label := Label.new()
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.z_index = 20
	get_tree().current_scene.add_child(label)
	label.global_position = pos + Vector2(-label.size.x / 2.0, 0)
	var tween := label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", pos.y - 40, 0.8)
	tween.tween_property(label, "modulate:a", 0.0, 0.8).set_delay(0.2)
	tween.chain().tween_callback(label.queue_free)

func spawn_damage_number(damage: float, pos: Vector2, is_critical: bool = false) -> void:
	var number := _damage_number_scene.instantiate()
	get_tree().current_scene.add_child(number)
	number.global_position = pos
	number.setup(damage, is_critical)

func spawn_hit_effect(pos: Vector2) -> void:
	for i in 5:
		var dot := ColorRect.new()
		dot.size = Vector2(3, 3)
		dot.color = Color(1.0, 0.9, 0.3, 1.0)
		dot.position = pos + Vector2(randf_range(-8, 8), randf_range(-8, 8))
		get_tree().current_scene.add_child(dot)
		var tween := dot.create_tween()
		tween.set_parallel(true)
		tween.tween_property(dot, "position", dot.position + Vector2(randf_range(-15, 15), randf_range(-15, 15)), 0.3)
		tween.tween_property(dot, "modulate:a", 0.0, 0.3)
		tween.chain().tween_callback(dot.queue_free)

func spawn_death_effect(pos: Vector2) -> void:
	for i in 8:
		var particle := ColorRect.new()
		particle.size = Vector2(4, 4)
		particle.color = Color(0.8, 0.2, 0.2, 1.0)
		particle.position = pos + Vector2(randf_range(-6, 6), randf_range(-6, 6))
		get_tree().current_scene.add_child(particle)
		var angle: float = TAU * i / 8.0
		var dist: float = randf_range(20, 40)
		var target_pos: float = particle.position.x + cos(angle) * dist
		var target_pos_y: float = particle.position.y + sin(angle) * dist
		var tween := particle.create_tween()
		tween.set_parallel(true)
		tween.tween_property(particle, "position", Vector2(target_pos, target_pos_y), 0.4)
		tween.tween_property(particle, "modulate:a", 0.0, 0.4)
		tween.chain().tween_callback(particle.queue_free)
