extends Node2D

## Arena - Small bounded gameplay map.

const ARENA_SIZE: Vector2 = Vector2(1200, 900)
const WALL_THICKNESS: float = 20.0

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D

var _wave_manager: Node
var _enemy_spawner: Node
var _prep_timer: float = 0.0
var _prep_delay: float = 2.0
var _waiting_for_prep: bool = false
var _interstitial_count: int = 0

func _ready() -> void:
	_create_walls()
	_setup_systems()
	_setup_camera()
	EventBus.shop_closed.connect(_on_shop_closed)
	EventBus.player_revived.connect(_on_player_revived)
	EventBus.player_died.connect(_on_player_died)
	_start_prep()

func _create_walls() -> void:
	var wall_color: Color = Color(0.3, 0.3, 0.35)
	_add_wall(Vector2(ARENA_SIZE.x / 2.0, -WALL_THICKNESS / 2.0), Vector2(ARENA_SIZE.x, WALL_THICKNESS), wall_color)
	_add_wall(Vector2(ARENA_SIZE.x / 2.0, ARENA_SIZE.y + WALL_THICKNESS / 2.0), Vector2(ARENA_SIZE.x, WALL_THICKNESS), wall_color)
	_add_wall(Vector2(-WALL_THICKNESS / 2.0, ARENA_SIZE.y / 2.0), Vector2(WALL_THICKNESS, ARENA_SIZE.y), wall_color)
	_add_wall(Vector2(ARENA_SIZE.x + WALL_THICKNESS / 2.0, ARENA_SIZE.y / 2.0), Vector2(WALL_THICKNESS, ARENA_SIZE.y), wall_color)

func _add_wall(pos: Vector2, size: Vector2, color: Color) -> void:
	var body := StaticBody2D.new()
	body.position = pos
	body.collision_layer = 0
	body.collision_mask = 1
	add_child(body)
	var col := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = size
	col.shape = shape
	body.add_child(col)
	var visual := ColorRect.new()
	visual.size = size
	visual.position = -size / 2.0
	visual.color = color
	body.add_child(visual)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, ARENA_SIZE), Color(0.15, 0.15, 0.2))
	var grid_color: Color = Color(0.2, 0.2, 0.25, 0.3)
	var spacing: float = 40.0
	var x: float = spacing
	while x < ARENA_SIZE.x:
		draw_line(Vector2(x, 0), Vector2(x, ARENA_SIZE.y), grid_color, 1.0)
		x += spacing
	var y: float = spacing
	while y < ARENA_SIZE.y:
		draw_line(Vector2(0, y), Vector2(ARENA_SIZE.x, y), grid_color, 1.0)
		y += spacing

func _setup_systems() -> void:
	_enemy_spawner = Node.new()
	_enemy_spawner.name = "EnemySpawner"
	_enemy_spawner.set_script(load("res://enemies/enemy_spawner.gd"))
	add_child(_enemy_spawner)
	_enemy_spawner.initialize(self)

	_wave_manager = Node.new()
	_wave_manager.name = "WaveManager"
	_wave_manager.set_script(load("res://waves/wave_manager.gd"))
	add_child(_wave_manager)
	_wave_manager.initialize(_enemy_spawner)

	var hud := preload("res://ui/hud/hud.tscn").instantiate()
	add_child(hud)

	var upgrade_ui := preload("res://ui/upgrade/upgrade_ui.tscn").instantiate()
	add_child(upgrade_ui)

	var shop_ui := preload("res://ui/shop/shop_ui.tscn").instantiate()
	add_child(shop_ui)

	var screen_effects := preload("res://effects/screen_effects.tscn").instantiate()
	add_child(screen_effects)

	var currency_manager := preload("res://economy/currency_manager.gd").new()
	currency_manager.name = "CurrencyManager"
	add_child(currency_manager)

	var stats_panel := preload("res://ui/hud/stats_panel.tscn").instantiate()
	add_child(stats_panel)

	var pause_menu := preload("res://ui/pause/pause_menu.tscn").instantiate()
	add_child(pause_menu)

	var settings_ui := preload("res://ui/settings/settings_ui.tscn").instantiate()
	add_child(settings_ui)
	pause_menu.settings_ui = settings_ui

	var team_display := preload("res://ui/hud/team_display.tscn").instantiate()
	add_child(team_display)

	var game_over_ui := preload("res://ui/game_over/game_over.tscn").instantiate()
	add_child(game_over_ui)

	var rewarded_ad_panel := preload("res://ui/rewarded_ad/rewarded_ad_panel.tscn").instantiate()
	add_child(rewarded_ad_panel)

	var joystick := preload("res://ui/virtual_joystick/virtual_joystick.tscn").instantiate()
	joystick.name = "VirtualJoystick"
	joystick.set_process_input(true)
	add_child(joystick)

	var buttons := preload("res://ui/touch_buttons/touch_buttons.tscn").instantiate()
	buttons.name = "TouchButtons"
	buttons.set_process_input(true)
	add_child(buttons)

	_spawn_starting_companion()
	_spawn_starting_weapons()

func _setup_camera() -> void:
	if player and camera:
		camera.make_current()
		camera.position = ARENA_SIZE / 2.0
		_update_camera_zoom()
		get_viewport().size_changed.connect(_update_camera_zoom)

func _update_camera_zoom() -> void:
	if not camera:
		return
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var zoom_x: float = viewport_size.x / ARENA_SIZE.x
	var zoom_y: float = viewport_size.y / ARENA_SIZE.y
	var zoom_factor: float = minf(zoom_x, zoom_y) * 0.9
	camera.zoom = Vector2(zoom_factor, zoom_factor)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		GameManager.toggle_pause()

	if player:
		player.position = player.position.clamp(Vector2.ZERO, ARENA_SIZE)

	if _waiting_for_prep:
		_prep_timer -= delta
		if _prep_timer <= 0.0:
			_waiting_for_prep = false
			_wave_manager.start_next_wave()

	if _wave_manager and _wave_manager.is_wave_active():
		DataBus.update_effects(delta)

func _start_prep() -> void:
	_waiting_for_prep = true
	_prep_timer = _prep_delay

func _on_shop_closed() -> void:
	_show_interstitial_if_needed()
	_start_prep()

func _on_player_revived() -> void:
	var player: Node = GameManager.get_player()
	if not player:
		return
	var health_comp: HealthComponent = player.get_node_or_null("HealthComponent")
	if not health_comp:
		return
	health_comp._is_dead = false
	get_tree().paused = false
	print("[Arena] Player revived, resuming wave")

func _on_player_died() -> void:
	# Stop all spawning and clear enemies when player dies
	var spawner := get_node_or_null("EnemySpawner")
	if spawner and spawner.has_method("stop_spawning"):
		spawner.stop_spawning()

func _show_interstitial_if_needed() -> void:
	if not AdManager.is_initialized:
		return
	_interstitial_count += 1
	if _interstitial_count % 3 == 2:
		AdManager.show_interstitial("interstitial_main")

func _spawn_starting_companion() -> void:
	if not player or DataBus.starting_companion_key == "":
		return
	var companion_data: CompanionData = CompanionDatabase.get_companion(DataBus.starting_companion_key)
	if not companion_data:
		return
	var companion_script := preload("res://companions/companion_node.gd")
	var node := Node2D.new()
	node.name = companion_data.companion_name
	node.set_script(companion_script)
	player.add_child(node)
	node.set_companion_data(companion_data)
	DataBus.owned_companions.append(DataBus.starting_companion_key)
	EventBus.companion_team_changed.emit()

func _spawn_starting_weapons() -> void:
	if not player:
		return
	var pivot: Node2D = player.get_node_or_null("WeaponPivot")
	if not pivot:
		return
	var combat: Node = player.get_node_or_null("PlayerCombat")
	if not combat:
		return
	for weapon_key in DataBus.starting_weapons:
		var weapon_data: WeaponData = WeaponDatabase.get_weapon(weapon_key)
		if not weapon_data:
			continue
		var weapon_scene := preload("res://weapons/weapon_base.tscn")
		var weapon: Node2D = weapon_scene.instantiate()
		weapon.name = weapon_data.weapon_name
		pivot.add_child(weapon)
		weapon.set_weapon_data(weapon_data)
		combat.add_weapon(weapon)
