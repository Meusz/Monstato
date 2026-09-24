extends Area2D

## CoinPickup - Golden coin fragment dropped by enemies.
## Sits on ground with bobbing animation. Collected on wave end.

var coin_value: int = 1
var _bob_time: float = 0.0
var _bob_speed: float = 3.0
var _bob_height: float = 3.0
var _base_y: float = 0.0
var _sprite: Sprite2D
var _collected: bool = false
var _flying: bool = false
var _fly_speed: float = 600.0

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
	_sprite = Sprite2D.new()
	_sprite.texture = SpriteGenerator.coin()
	_sprite.scale = Vector2(0.8, 0.8)
	add_child(_sprite)
	_base_y = position.y

func _process(delta: float) -> void:
	if _collected:
		return
	if _flying:
		var player := GameManager.get_player()
		if player:
			var dir: Vector2 = (player.global_position - global_position).normalized()
			global_position += dir * _fly_speed * delta
			if global_position.distance_to(player.global_position) < 15.0:
				_collect()
		return
	var player := GameManager.get_player()
	if player:
		var collect_range: float = DataBus.player_stats.get("pickup_range", 50.0)
		if global_position.distance_to(player.global_position) <= collect_range:
			_collect()
			return
	_bob_time += delta * _bob_speed
	_sprite.position.y = sin(_bob_time) * _bob_height

func setup(pos: Vector2, value: int) -> void:
	global_position = pos
	_base_y = pos.y
	coin_value = value

func start_flying() -> void:
	_flying = true
	collision_mask = 0

func _collect() -> void:
	if _collected:
		return
	_collected = true
	var harvesting: float = DataBus.player_stats.get("harvesting", 0.0)
	var bonus: float = clampf(harvesting / 100.0, 0.0, 1.0)
	var final_value: int = maxi(1, coin_value + int(coin_value * bonus))
	DataBus.add_currency(final_value)
	_spawn_floating_text(final_value)
	queue_free()

func _spawn_floating_text(amount: int) -> void:
	var label := Label.new()
	label.text = "+%d" % amount
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
	label.position = global_position + Vector2(-10, -10)
	label.z_index = 10
	var scene_tree := get_tree()
	if scene_tree and scene_tree.current_scene:
		scene_tree.current_scene.add_child(label)
		var tween := label.create_tween()
		tween.tween_property(label, "position:y", label.position.y - 30, 0.6)
		tween.parallel().tween_property(label, "modulate:a", 0.0, 0.6)
		tween.tween_callback(label.queue_free)
