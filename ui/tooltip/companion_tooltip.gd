extends CanvasLayer

## CompanionTooltip - Floating tooltip showing companion stats on hover.

@onready var panel: PanelContainer = $PanelContainer
@onready var rich_text: RichTextLabel = $PanelContainer/RichTextLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide_tooltip()

func _process(_delta: float) -> void:
	if visible:
		_follow_mouse()

func _follow_mouse() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var tooltip_size: Vector2 = panel.size
	var pos: Vector2 = mouse_pos + Vector2(16, 16)
	if pos.x + tooltip_size.x > viewport_size.x:
		pos.x = mouse_pos.x - tooltip_size.x - 16
	if pos.y + tooltip_size.y > viewport_size.y:
		pos.y = viewport_size.y - tooltip_size.y - 4
	if pos.y < 0:
		pos.y = 4
	panel.position = pos

func show_tooltip(data: CompanionData, extra_info: String = "") -> void:
	var combat: String = "M" if data.combat_type == CompanionData.CombatType.MELEE else "R"
	var type_col: Color = data.get_type_color()

	var text: String = "[color=#%s]%s[/color] %s Lv.%d | " % [type_col.to_html(false), data.companion_name, combat, data.level]
	text += "[color=#ff6666]%d DMG[/color] " % int(data.base_damage)
	text += "[color=#66ff66]%.1f SPD[/color] " % data.attack_speed
	text += "[color=#66aaff]%d RNG[/color]" % int(data.attack_range)

	rich_text.text = text
	visible = true
	_follow_mouse()

func hide_tooltip() -> void:
	visible = false
