extends PanelContainer

## ShopItemSlot - A single slot in the shop for companions or items.

signal purchased

@onready var icon: TextureRect = $VBoxContainer/Icon
@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var desc_label: Label = $VBoxContainer/DescLabel
@onready var cost_label: Label = $VBoxContainer/CostLabel
@onready var rarity_label: Label = $VBoxContainer/RarityLabel
@onready var type_label: Label = $VBoxContainer/TypeLabel
@onready var buy_button: Button = $VBoxContainer/BuyButton

var _cost: int = 0
var _companion_data: CompanionData = null
var _tooltip_scene: PackedScene = preload("res://ui/tooltip/companion_tooltip.tscn")
var _tooltip: CanvasLayer = null

func _ready() -> void:
	mouse_entered.connect(_on_hover.bind(true))
	mouse_exited.connect(_on_hover.bind(false))

func _create_tooltip() -> CanvasLayer:
	if not _tooltip or not is_instance_valid(_tooltip):
		_tooltip = _tooltip_scene.instantiate()
		get_tree().current_scene.add_child(_tooltip)
	return _tooltip

func _on_hover(hovering: bool) -> void:
	if not _companion_data:
		return
	var tip := _create_tooltip()
	if hovering:
		tip.show_tooltip(_companion_data)
	else:
		tip.hide_tooltip()

func setup_companion(companion: Variant, suffix: String = "") -> void:
	if companion is CompanionData:
		var c: CompanionData = companion as CompanionData
		_cost = c.cost
		_companion_data = c
		name_label.text = c.companion_name + suffix
		desc_label.text = c.description
		cost_label.text = "$%d" % _cost
		rarity_label.text = c.get_phase_name()
		rarity_label.add_theme_color_override("font_color", c.get_phase_color())
		type_label.text = "%s | %s" % [c.get_type_name(), "Melee" if c.combat_type == CompanionData.CombatType.MELEE else "Ranged"]
		type_label.add_theme_color_override("font_color", c.get_type_color())
		icon.texture = _get_companion_texture(c)
		icon.modulate = c.get_type_color()
	elif companion is WeaponData:
		var w: WeaponData = companion as WeaponData
		name_label.text = w.weapon_name + suffix
		desc_label.text = w.description
		rarity_label.text = w.get_rarity_name() if w.has_method("get_rarity_name") else ""
		rarity_label.add_theme_color_override("font_color", w.get_rarity_color() if w.has_method("get_rarity_color") else Color.WHITE)
		type_label.text = "DMG:%d SPD:%.1f RNG:%d" % [int(w.base_damage), w.attack_speed, int(w.attack_range)]
		icon.texture = null
	else:
		return
	buy_button.pressed.connect(_on_buy_pressed)
	_update_afford()

func setup_item(item: ItemData) -> void:
	_cost = item.cost
	icon.texture = null
	name_label.text = item.item_name
	desc_label.text = item.description
	cost_label.text = "$%d" % _cost
	rarity_label.text = item.get_rarity_name()
	rarity_label.add_theme_color_override("font_color", item.get_rarity_color())
	type_label.text = ""
	buy_button.pressed.connect(_on_buy_pressed)
	_update_afford()

func setup_upgrade(name: String, current: int, cost: int) -> void:
	_cost = cost
	name_label.text = name
	desc_label.text = "Current: %d" % current
	cost_label.text = "$%d" % cost
	rarity_label.text = ""
	type_label.text = ""
	buy_button.text = "UPGRADE"
	buy_button.pressed.connect(_on_buy_pressed)
	_update_afford()

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

func _update_afford() -> void:
	var can_afford: bool = DataBus.currency >= _cost
	buy_button.disabled = not can_afford
	if can_afford:
		cost_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		cost_label.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))

func _on_buy_pressed() -> void:
	purchased.emit()
