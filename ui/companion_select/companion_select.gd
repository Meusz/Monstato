extends Control

## CompanionSelect - Hover to see stats + SELECT on each companion.

@onready var companions_grid: GridContainer = $VBoxContainer/ScrollContainer/CompanionsGrid

var _companions: Array = []
var _selected_index: int = -1
var _slot_panels: Array[PanelContainer] = []
var _slot_stats: Array[RichTextLabel] = []
var _slot_buttons: Array[Button] = []
var _slot_styles: Array[StyleBoxFlat] = []
var _tooltip_scene: PackedScene = preload("res://ui/tooltip/companion_tooltip.tscn")
var _tooltip: CanvasLayer = null

func _ready() -> void:
	_load_companions()
	_build_grid()

func _load_companions() -> void:
	_companions.clear()
	for key in CompanionDatabase.get_companion_keys():
		var c: CompanionData = CompanionDatabase.get_companion(key)
		if c.phase == 1:
			_companions.append(c)

func _build_grid() -> void:
	for child in companions_grid.get_children():
		child.queue_free()
	_slot_panels.clear()
	_slot_stats.clear()
	_slot_buttons.clear()
	_slot_styles.clear()
	companions_grid.columns = 5
	for i in _companions.size():
		var companion: CompanionData = _companions[i]
		var result: Array = _create_slot(companion, i)
		var panel: PanelContainer = result[0]
		var stats_lbl: RichTextLabel = result[1]
		var btn: Button = result[2]
		var base_style: StyleBoxFlat = result[3]
		_slot_panels.append(panel)
		_slot_stats.append(stats_lbl)
		_slot_buttons.append(btn)
		_slot_styles.append(base_style)
		companions_grid.add_child(panel)

func _create_slot(companion: CompanionData, index: int) -> Array:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(160, 180)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var base_style := StyleBoxFlat.new()
	base_style.bg_color = Color(0.12, 0.12, 0.18, 0.95)
	base_style.border_width_left = 2
	base_style.border_width_top = 2
	base_style.border_width_right = 2
	base_style.border_width_bottom = 2
	base_style.border_color = Color(0.3, 0.3, 0.4, 0.5)
	base_style.corner_radius_top_left = 6
	base_style.corner_radius_top_right = 6
	base_style.corner_radius_bottom_right = 6
	base_style.corner_radius_bottom_left = 6
	base_style.content_margin_left = 8.0
	base_style.content_margin_top = 8.0
	base_style.content_margin_right = 8.0
	base_style.content_margin_bottom = 8.0
	panel.add_theme_stylebox_override("panel", base_style)

	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 4)
	panel.add_child(vbox)

	var icon_tex := TextureRect.new()
	icon_tex.custom_minimum_size = Vector2(48, 48)
	icon_tex.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_tex.texture = _get_companion_texture(companion)
	icon_tex.modulate = companion.get_type_color()
	vbox.add_child(icon_tex)

	var name_lbl := Label.new()
	name_lbl.text = companion.companion_name
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 14)
	vbox.add_child(name_lbl)

	var type_lbl := Label.new()
	type_lbl.text = "%s | %s" % [companion.get_type_name(), "Melee" if companion.combat_type == CompanionData.CombatType.MELEE else "Ranged"]
	type_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	type_lbl.add_theme_font_size_override("font_size", 12)
	type_lbl.add_theme_color_override("font_color", companion.get_type_color())
	vbox.add_child(type_lbl)

	var stats_lbl := RichTextLabel.new()
	stats_lbl.bbcode_enabled = true
	stats_lbl.fit_content = true
	stats_lbl.scroll_active = false
	stats_lbl.modulate.a = 0.0
	stats_lbl.add_theme_font_size_override("normal_font_size", 12)
	var combat: String = "Melee" if companion.combat_type == CompanionData.CombatType.MELEE else "Ranged"
	stats_lbl.text = "[color=#44ff44]DMG:%d[/color] [color=#44ff44]SPD:%.1f[/color] [color=#44ff44]RNG:%d[/color]" % [int(companion.base_damage), companion.attack_speed, int(companion.attack_range)]
	vbox.add_child(stats_lbl)

	var btn := Button.new()
	btn.text = "FREE"
	btn.custom_minimum_size = Vector2(0, 28)
	btn.add_theme_font_size_override("font_size", 13)
	btn.modulate.a = 0.0
	btn.pressed.connect(_on_slot_clicked.bind(index))
	vbox.add_child(btn)

	panel.mouse_entered.connect(_on_slot_hover.bind(index, true))
	panel.mouse_exited.connect(_on_slot_hover.bind(index, false))
	panel.gui_input.connect(_on_slot_gui_input.bind(index))
	return [panel, stats_lbl, btn, base_style]

func _on_slot_hover(index: int, hovering: bool) -> void:
	_slot_stats[index].modulate.a = 1.0 if hovering else 0.0
	_slot_buttons[index].modulate.a = 1.0 if hovering else 0.0
	_update_slot_style(index, hovering)
	var tip := _get_companion_tooltip()
	if hovering:
		tip.show_tooltip(_companions[index])
	else:
		tip.hide_tooltip()

func _get_companion_tooltip() -> CanvasLayer:
	if not _tooltip or not is_instance_valid(_tooltip):
		_tooltip = _tooltip_scene.instantiate()
		add_child(_tooltip)
	return _tooltip

func _update_slot_style(index: int, hovering: bool) -> void:
	var style: StyleBoxFlat = _slot_styles[index].duplicate() as StyleBoxFlat
	if index == _selected_index:
		style.border_color = Color(1.0, 0.85, 0.2, 1.0)
		style.border_width_left = 3
		style.border_width_top = 3
		style.border_width_right = 3
		style.border_width_bottom = 3
	elif hovering:
		style.border_color = Color(0.7, 0.7, 0.8, 0.8)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
	else:
		style.border_color = Color(0.3, 0.3, 0.4, 0.5)
		style.border_width_left = 2
		style.border_width_top = 2
		style.border_width_right = 2
		style.border_width_bottom = 2
	_slot_panels[index].add_theme_stylebox_override("panel", style)

func _on_slot_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_slot_clicked(index)

func _on_slot_clicked(index: int) -> void:
	_selected_index = index
	for i in _slot_panels.size():
		_update_slot_style(i, i == index)
	_confirm(index)

func _confirm(index: int) -> void:
	var companion: CompanionData = _companions[index]
	DataBus.starting_companion_key = companion.companion_key
	EventBus.scene_change_requested.emit("res://maps/arena/arena.tscn")

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
