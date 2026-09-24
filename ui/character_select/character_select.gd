extends Control

## CharacterSelect - All trainers shown. Hover to see stats + SELECT.

@onready var cards_container: HBoxContainer = $MarginContainer/VBox/Scroll/CardsContainer

var _selected_index: int = -1
var _character_cards: Array[Dictionary] = []
var _card_panels: Array[PanelContainer] = []
var _card_stats: Array[RichTextLabel] = []
var _card_buttons: Array[Button] = []
var _card_styles: Array[StyleBoxFlat] = []

func _ready() -> void:
	_register_characters()
	_build_cards()

func _register_characters() -> void:
	var warrior := CharacterData.new()
	warrior.character_name = "Warrior"
	warrior.description = "Balanced fighter. Strong up close, tough to kill."
	warrior.sprite_color = Color(0.8, 0.2, 0.2)
	warrior.max_health = 120.0
	warrior.damage = 10.0
	warrior.armor = 8.0
	warrior.melee_damage = 5.0
	warrior.speed = 180.0
	warrior.range = -10.0
	_character_cards.append({"data": warrior, "bonuses": ["+20 HP", "+8 ARM", "+5 M.DMG"], "penalties": ["-20 SPD", "-10 RNG"]})

	var ranger := CharacterData.new()
	ranger.character_name = "Ranger"
	ranger.description = "Fast & deadly. High crit, low defense."
	ranger.sprite_color = Color(0.2, 0.8, 0.2)
	ranger.max_health = 75.0
	ranger.speed = 260.0
	ranger.crit_chance = 0.15
	ranger.ranged_damage = 5.0
	ranger.attack_speed = 15.0
	ranger.armor = 0.0
	_character_cards.append({"data": ranger, "bonuses": ["+60 SPD", "+15% CRT", "+5 R.DMG", "+15 ATK.S"], "penalties": ["-25 HP", "-5 ARM"]})

	var tank := CharacterData.new()
	tank.character_name = "Tank"
	tank.description = "Nearly unkillable. Slow and steady."
	tank.sprite_color = Color(0.4, 0.4, 0.8)
	tank.max_health = 200.0
	tank.armor = 18.0
	tank.regeneration = 1.5
	tank.speed = 140.0
	tank.damage = 3.0
	tank.attack_speed = -10.0
	_character_cards.append({"data": tank, "bonuses": ["+100 HP", "+18 ARM", "+1.5 RGN"], "penalties": ["-60 SPD", "-7 DMG", "-10 ATK.S"]})

	var mage := CharacterData.new()
	mage.character_name = "Mage"
	mage.description = "Devastating ranged power. Fragile body."
	mage.sprite_color = Color(0.7, 0.2, 0.9)
	mage.max_health = 65.0
	mage.damage = 18.0
	mage.range = 30.0
	mage.elemental_damage = 8.0
	mage.projectile_count = 2
	mage.crit_chance = 0.10
	mage.armor = 0.0
	mage.speed = 185.0
	_character_cards.append({"data": mage, "bonuses": ["+18 DMG", "+30 RNG", "+8 E.DMG", "+2 PRJ", "+10% CRT"], "penalties": ["-35 HP", "-5 ARM"]})

func _build_cards() -> void:
	for child in cards_container.get_children():
		child.queue_free()
	_card_panels.clear()
	_card_stats.clear()
	_card_buttons.clear()
	_card_styles.clear()
	for i in _character_cards.size():
		var card_dict: Dictionary = _character_cards[i]
		var c: CharacterData = card_dict["data"]
		var result: Array = _create_card(c, card_dict["bonuses"], card_dict["penalties"], i)
		var panel: PanelContainer = result[0]
		var stats_lbl: RichTextLabel = result[1]
		var btn: Button = result[2]
		var base_style: StyleBoxFlat = result[3]
		_card_panels.append(panel)
		_card_stats.append(stats_lbl)
		_card_buttons.append(btn)
		_card_styles.append(base_style)
		cards_container.add_child(panel)

func _create_card(c: CharacterData, bonuses: Array, penalties: Array, index: int) -> Array:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(220, 380)
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var base_style := StyleBoxFlat.new()
	base_style.bg_color = Color(0.12, 0.12, 0.18, 0.95)
	base_style.border_width_left = 2
	base_style.border_width_top = 2
	base_style.border_width_right = 2
	base_style.border_width_bottom = 2
	base_style.border_color = Color(0.3, 0.3, 0.4, 0.5)
	base_style.corner_radius_top_left = 8
	base_style.corner_radius_top_right = 8
	base_style.corner_radius_bottom_right = 8
	base_style.corner_radius_bottom_left = 8
	base_style.content_margin_left = 10.0
	base_style.content_margin_top = 10.0
	base_style.content_margin_right = 10.0
	base_style.content_margin_bottom = 10.0
	panel.add_theme_stylebox_override("panel", base_style)
	panel.name = "Card_%d_%s" % [index, c.character_name]

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	panel.add_child(vbox)

	var sprite_rect := TextureRect.new()
	sprite_rect.custom_minimum_size = Vector2(80, 80)
	sprite_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite_rect.texture = _get_portrait(c)
	sprite_rect.modulate = c.sprite_color
	sprite_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(sprite_rect)

	var name_lbl := Label.new()
	name_lbl.text = c.character_name
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 22)
	name_lbl.add_theme_color_override("font_color", c.sprite_color)
	vbox.add_child(name_lbl)

	var sep := HSeparator.new()
	vbox.add_child(sep)

	var desc_lbl := Label.new()
	desc_lbl.text = c.description
	desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_lbl.add_theme_font_size_override("font_size", 14)
	desc_lbl.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	vbox.add_child(desc_lbl)

	var stats_lbl := RichTextLabel.new()
	stats_lbl.bbcode_enabled = true
	stats_lbl.fit_content = true
	stats_lbl.scroll_active = false
	stats_lbl.modulate.a = 0.0
	stats_lbl.add_theme_font_size_override("normal_font_size", 14)
	var bbcode: String = ""
	for b in bonuses:
		bbcode += "[color=#44ff44]%s[/color]  " % b
	bbcode += "\n"
	for p in penalties:
		bbcode += "[color=#ff4444]%s[/color]  " % p
	stats_lbl.text = bbcode
	vbox.add_child(stats_lbl)

	var btn := Button.new()
	btn.text = "SELECT"
	btn.custom_minimum_size = Vector2(0, 36)
	btn.add_theme_font_size_override("font_size", 16)
	btn.modulate.a = 0.0
	btn.pressed.connect(_on_card_clicked.bind(index))
	vbox.add_child(btn)

	panel.mouse_entered.connect(_on_card_hover.bind(index, true))
	panel.mouse_exited.connect(_on_card_hover.bind(index, false))
	panel.gui_input.connect(_on_card_gui_input.bind(index))
	return [panel, stats_lbl, btn, base_style]

func _on_card_hover(index: int, hovering: bool) -> void:
	_card_stats[index].modulate.a = 1.0 if hovering else 0.0
	_card_buttons[index].modulate.a = 1.0 if hovering else 0.0
	_update_card_style(index, hovering)

func _on_card_gui_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_on_card_clicked(index)

func _update_card_style(index: int, hovering: bool) -> void:
	var style: StyleBoxFlat = _card_styles[index].duplicate() as StyleBoxFlat
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
	_card_panels[index].add_theme_stylebox_override("panel", style)

func _on_card_clicked(index: int) -> void:
	_selected_index = index
	for i in _card_panels.size():
		_update_card_style(i, i == index)
	_confirm(index)

func _confirm(index: int) -> void:
	var char: CharacterData = _character_cards[index]["data"]
	DataBus.reset_runtime_data()
	DataBus.player_stats = char.to_dict()
	DataBus.starting_weapons = char.starting_weapons.duplicate()
	EventBus.scene_change_requested.emit("res://ui/companion_select/companion_select.tscn")

func _get_portrait(c: CharacterData) -> Texture2D:
	match c.character_name:
		"Warrior": return SpriteGenerator.player_warrior()
		"Ranger": return SpriteGenerator.player_ranger()
		"Tank": return SpriteGenerator.player_tank()
		"Mage": return SpriteGenerator.player_mage()
		_: return SpriteGenerator.player_warrior()
