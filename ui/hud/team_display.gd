extends CanvasLayer

## TeamDisplay - Shows deployed (3) and reserve (3) companions.
## Click to toggle deploy/undeploy. Hover for stats.

@onready var panel: PanelContainer = $PanelContainer
@onready var deployed_hbox: HBoxContainer = $PanelContainer/VBox/DeployedSection/DeployedHBox
@onready var reserve_hbox: HBoxContainer = $PanelContainer/VBox/ReserveSection/ReserveHBox
@onready var deployed_label: Label = $PanelContainer/VBox/DeployedSection/Label
@onready var reserve_label: Label = $PanelContainer/VBox/ReserveSection/Label

var _tooltip_scene: PackedScene = preload("res://ui/tooltip/companion_tooltip.tscn")
var _tooltip: CanvasLayer = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.companion_team_changed.connect(_refresh_display)
	EventBus.shop_opened.connect(_refresh_display)
	_refresh_display()

func _create_tooltip() -> CanvasLayer:
	if not _tooltip or not is_instance_valid(_tooltip):
		_tooltip = _tooltip_scene.instantiate()
		add_child(_tooltip)
	return _tooltip

func _refresh_display() -> void:
	for child in deployed_hbox.get_children():
		child.queue_free()
	for child in reserve_hbox.get_children():
		child.queue_free()
	var player := GameManager.get_player()
	if not player:
		return
	var deployed_count: int = 0
	var reserve_count: int = 0
	for child in player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			if child.deployed:
				_add_icon(deployed_hbox, child.companion_data, true)
				deployed_count += 1
			else:
				_add_icon(reserve_hbox, child.companion_data, false)
				reserve_count += 1
	deployed_label.text = "DEPLOYED (%d/%d)" % [deployed_count, DataBus.max_deployed]
	reserve_label.text = "RESERVE (%d/%d)" % [reserve_count, DataBus.max_reserve]

func _add_icon(parent: HBoxContainer, data: CompanionData, is_deployed: bool) -> void:
	var container := VBoxContainer.new()
	container.alignment = BoxContainer.ALIGNMENT_CENTER
	container.custom_minimum_size = Vector2(64, 80)
	container.mouse_filter = Control.MOUSE_FILTER_STOP
	container.mouse_entered.connect(_on_slot_hover.bind(data, true))
	container.mouse_exited.connect(_on_slot_hover.bind(data, false))
	parent.add_child(container)
	var sprite_rect := TextureRect.new()
	sprite_rect.custom_minimum_size = Vector2(48, 48)
	sprite_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite_rect.texture = _get_companion_texture(data)
	sprite_rect.modulate = data.get_type_color() if is_deployed else Color(data.get_type_color(), 0.4)
	container.add_child(sprite_rect)
	var name_lbl := Label.new()
	name_lbl.text = data.companion_name.left(8)
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 10)
	container.add_child(name_lbl)
	var phase_lbl := Label.new()
	phase_lbl.text = "Ph.%d Lv.%d" % [data.phase, data.level]
	phase_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	phase_lbl.add_theme_font_size_override("font_size", 9)
	phase_lbl.add_theme_color_override("font_color", data.get_phase_color())
	container.add_child(phase_lbl)
	var btn := Button.new()
	btn.text = "UNDPLY" if is_deployed else "DEPLOY"
	btn.custom_minimum_size = Vector2(60, 22)
	btn.add_theme_font_size_override("font_size", 9)
	container.add_child(btn)
	btn.pressed.connect(_on_toggle_deploy.bind(data.companion_key))

func _on_slot_hover(data: CompanionData, hovering: bool) -> void:
	var tip := _create_tooltip()
	if hovering:
		tip.show_tooltip(data)
	else:
		tip.hide_tooltip()

func _on_toggle_deploy(companion_key: String) -> void:
	var player := GameManager.get_player()
	if not player:
		return
	for child in player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			if child.companion_data.companion_key == companion_key:
				if child.deployed:
					var deployed_count: int = 0
					for c2 in player.get_children():
						if c2.has_method("set_companion_data") and c2.companion_data and c2.deployed:
							deployed_count += 1
					if deployed_count <= 1:
						return
					child.deployed = false
					child.global_position = player.global_position
				else:
					var deployed_count: int = 0
					for c2 in player.get_children():
						if c2.has_method("set_companion_data") and c2.companion_data and c2.deployed:
							deployed_count += 1
					if deployed_count >= DataBus.max_deployed:
						return
					child.deployed = true
					child.global_position = player.global_position
				_refresh_display()
				return

func _get_companion_texture(data: CompanionData) -> Texture2D:
	match data.companion_key:
		"slime": return SpriteGenerator.companion_slime()
		"spider": return SpriteGenerator.companion_poison_spider()
		"stone_golem": return SpriteGenerator.companion_stone_golem()
		"lightning_bug": return SpriteGenerator.companion_lightning_bug()
		"fire_spirit": return SpriteGenerator.companion_fire_spirit()
		"phoenix": return SpriteGenerator.companion_phoenix()
		"skeleton": return SpriteGenerator.companion_skeleton()
		"ice_crystal": return SpriteGenerator.companion_ice_crystal()
		"shadow_cat": return SpriteGenerator.companion_shadow_cat()
		"bat": return SpriteGenerator.companion_bat()
		_: return SpriteGenerator.companion_slime()
