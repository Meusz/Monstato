extends CanvasLayer

## ShopUI - Shows companions, weapons, items for purchase between waves.

@onready var companions_grid: HBoxContainer = $CenterContainer/VBoxContainer/CompanionsSection/CompanionsGrid
@onready var weapons_grid: HBoxContainer = $CenterContainer/VBoxContainer/WeaponsSection/WeaponsGrid
@onready var items_grid: HBoxContainer = $CenterContainer/VBoxContainer/ItemsSection/ItemsGrid
@onready var currency_label: Label = $CenterContainer/VBoxContainer/TopBar/CurrencyLabel
@onready var wave_label: Label = $CenterContainer/VBoxContainer/TopBar/WaveLabel
@onready var refresh_button: Button = $CenterContainer/VBoxContainer/BottomBar/RefreshButton
@onready var close_button: Button = $CenterContainer/VBoxContainer/BottomBar/CloseButton
@onready var upgrades_hbox: HBoxContainer = $CenterContainer/VBoxContainer/UpgradesSection/UpgradesHBox

var _shop_system: Node = null
var _player: Node = null
var _slot_scene: PackedScene = preload("res://ui/shop/shop_item_slot.tscn")
## key → { phase: int, count: int, is_deployed: bool }
var _owned_companions: Dictionary = {}
## weapon_key → count
var _owned_weapons: Dictionary = {}
var _shop_timer: float = 0.0
var _shop_duration: float = 20.0
var _shop_timer_label: Label = null
var _weapons_for_sale: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	EventBus.shop_opened.connect(_on_shop_opened)
	EventBus.shop_refreshed.connect(_on_shop_refreshed)
	EventBus.item_purchased.connect(_on_item_purchased)
	refresh_button.pressed.connect(_on_refresh_pressed)
	close_button.pressed.connect(_on_close_pressed)

func _process(delta: float) -> void:
	if visible:
		_shop_timer -= delta
		if _shop_timer_label:
			_shop_timer_label.text = "Tienda: %.0fs" % _shop_timer
		if _shop_timer <= 0.0:
			_on_close_pressed()

func _on_shop_opened() -> void:
	_shop_system = get_node_or_null("/root/ShopSystem")
	_player = GameManager.get_player()
	_scan_owned_companions()
	_scan_owned_weapons()
	_refresh_display()
	_build_upgrades()
	_shop_timer = _shop_duration
	_create_timer_label()
	visible = true
	get_tree().paused = true

func _create_timer_label() -> void:
	if _shop_timer_label and is_instance_valid(_shop_timer_label):
		_shop_timer_label.queue_free()
	_shop_timer_label = Label.new()
	_shop_timer_label.add_theme_font_size_override("font_size", 24)
	_shop_timer_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2, 1.0))
	_shop_timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var top_bar = get_node_or_null("CenterContainer/VBoxContainer/TopBar")
	if top_bar:
		top_bar.add_child(_shop_timer_label)
	_shop_timer_label.position = Vector2(0, -30)
	_shop_timer_label.anchors_preset = Control.PRESET_TOP_WIDE
	_shop_timer_label.anchor_bottom = 0.0
	_shop_timer_label.offset_top = -30

func _on_shop_refreshed() -> void:
	_refresh_display()

func _scan_owned_companions() -> void:
	_owned_companions.clear()
	if not _player:
		return
	for child in _player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			var key: String = child.companion_data.companion_key
			if key == "":
				continue
			var ph: int = child.companion_data.phase
			if not _owned_companions.has(key):
				_owned_companions[key] = { "phase": ph, "count": 1 }
			else:
				_owned_companions[key]["count"] += 1

func _refresh_display() -> void:
	_clear_grid(companions_grid)
	_clear_grid(weapons_grid)
	_clear_grid(items_grid)
	_update_currency()
	if _shop_system:
		_display_companions(_shop_system.get_companions_for_sale())
		_weapons_for_sale = WeaponDatabase.get_random_weapons(4)
		_display_weapons(_weapons_for_sale)
		_display_items(_shop_system.get_items_for_sale())

func _clear_grid(grid: Node) -> void:
	for child in grid.get_children():
		child.queue_free()

func _display_companions(companions: Array) -> void:
	for i in companions.size():
		var companion: CompanionData = companions[i]
		var slot := _slot_scene.instantiate()
		companions_grid.add_child(slot)
		var suffix: String = ""
		if _owned_companions.has(companion.companion_key):
			var owned_phase: int = _owned_companions[companion.companion_key]["phase"]
			suffix = " (Ph.%d)" % owned_phase
		slot.setup_companion(companion, suffix)
		slot.purchased.connect(_on_companion_buy.bind(i))

func _display_sellable_companions() -> void:
	if not _player:
		return
	for child in _player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			var comp: CompanionData = child.companion_data
			var slot := _slot_scene.instantiate()
			slot.name_label.text = "%s Ph.%d" % [comp.companion_name, comp.phase]
			slot.desc_label.text = "Lv.%d | DMG:%.0f" % [comp.level, comp.base_damage]
			var sell_value: int = comp.get_sell_value() if comp.has_method("get_sell_value") else 5
			slot.cost_label.text = "$%d" % sell_value
			slot.rarity_label.text = ""
			slot.type_label.text = "SELL"
			slot.buy_button.text = "SELL"
			slot._cost = sell_value
			slot.buy_button.pressed.connect(_on_sell_companion.bind(comp.companion_key))
			slot._update_afford()

func _on_sell_companion(companion_key: String) -> void:
	if not _player or companion_key == "":
		return
	var target_child: Node = null
	for child in _player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			if child.companion_data.companion_key == companion_key:
				target_child = child
				break
	if not target_child:
		return
	var deployed_count: int = 0
	for c in _player.get_children():
		if c.has_method("set_companion_data") and c.companion_data and c.deployed:
			deployed_count += 1
	if target_child.deployed and deployed_count <= 1:
		return
	var refund: int = target_child.companion_data.get_sell_value() if target_child.companion_data.has_method("get_sell_value") else 5
	target_child.queue_free()
	DataBus.add_currency(refund)
	_refresh_display()

func _display_items(items: Array) -> void:
	for i in items.size():
		var item: ItemData = items[i]
		var slot := _slot_scene.instantiate()
		items_grid.add_child(slot)
		slot.setup_item(item)
		slot.purchased.connect(_on_item_buy.bind(i))

func _display_weapons(weapons: Array) -> void:
	for i in weapons.size():
		var weapon: WeaponData = weapons[i]
		var slot := _slot_scene.instantiate()
		weapons_grid.add_child(slot)
		slot.setup_companion(weapon, "")
		slot.buy_button.text = "BUY"
		slot.purchased.connect(_on_weapon_buy.bind(i))

func _on_companion_buy(index: int) -> void:
	if not _shop_system:
		return
	var companions: Array = _shop_system.get_companions_for_sale()
	if index < 0 or index >= companions.size():
		return
	var companion: CompanionData = companions[index]
	if _shop_system.buy_companion(index):
		_spawn_companion(companion)
		_refresh_display()

func _spawn_companion(companion_data: CompanionData) -> void:
	if not _player:
		return
	var key: String = companion_data.companion_key
	var current_phase: int = 0
	if _owned_companions.has(key):
		current_phase = _owned_companions[key]["phase"]

	# Own same companion → combine into next phase
	if _owned_companions.has(key) and current_phase < 4:
		_evolve_companion(key, current_phase)
		EventBus.companion_team_changed.emit()
		return

	# Different phase or new companion → add as reserve
	if _get_companion_count() >= DataBus.max_deployed + DataBus.max_reserve:
		DataBus.add_currency(companion_data.cost)
		return
	var companion_script := preload("res://companions/companion_node.gd")
	var node := Node2D.new()
	node.name = companion_data.companion_name
	node.set_script(companion_script)
	_player.add_child(node)
	node.set_companion_data(companion_data)
	node.deployed = false
	if not _owned_companions.has(key):
		_owned_companions[key] = { "phase": companion_data.phase, "count": 1 }
	else:
		_owned_companions[key]["count"] += 1
	DataBus.owned_companions.append(key)
	EventBus.companion_team_changed.emit()

func _evolve_companion(key: String, current_phase: int) -> void:
	if not _player:
		return
	var new_phase: int = current_phase + 1
	for child in _player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			if child.companion_data.companion_key == key and child.companion_data.phase == current_phase:
				var upgraded: CompanionData = child.companion_data.get_upgraded(new_phase)
				child.set_companion_data(upgraded)
				_owned_companions[key]["phase"] = new_phase
	EventBus.companion_team_changed.emit()

func _update_currency() -> void:
	currency_label.text = "$%d" % DataBus.currency
	wave_label.text = "Wave %d Complete" % DataBus.current_wave

func _get_companion_count() -> int:
	var count: int = 0
	for child in _player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			count += 1
	return count

func _on_item_buy(index: int) -> void:
	if not _shop_system:
		return
	if _shop_system.buy_item(index):
		var item: ItemData = _shop_system.get_items_for_sale()[index] if index < _shop_system.get_items_for_sale().size() else null
		if item:
			_apply_item(item)
		_refresh_display()

func _apply_item(item: ItemData) -> void:
	match item.item_type:
		ItemData.ItemType.PASSIVE, ItemData.ItemType.RELIC:
			if DataBus.equipped_items.size() >= DataBus.max_items:
				DataBus.add_currency(item.cost)
				return
			item.apply_modifiers()
			DataBus.equipped_items.append(item)
		ItemData.ItemType.CONSUMABLE:
			_apply_consumable(item)

func _apply_consumable(item: ItemData) -> void:
	match item.item_name:
		"Health Potion":
			DataBus.modify_stat("health", 30.0)
			EventBus.player_healed.emit(30.0)
		"Mega Health Potion":
			DataBus.modify_stat("health", 75.0)
			EventBus.player_healed.emit(75.0)
		"XP Orb":
			DataBus.add_currency(10)
		"Gold Chest":
			DataBus.add_currency(50)

func _on_refresh_pressed() -> void:
	if _shop_system:
		_shop_system.refresh_shop()

func _on_close_pressed() -> void:
	visible = false
	get_tree().paused = false
	EventBus.shop_closed.emit()

func _on_item_purchased(_item: Resource, _cost: int) -> void:
	_update_currency()

func _on_weapon_buy(index: int) -> void:
	if not _player or index < 0 or index >= _weapons_for_sale.size():
		return
	var weapon_data: WeaponData = _weapons_for_sale[index]
	if _get_weapon_count() >= DataBus.max_weapons:
		return
	if not DataBus.spend_currency(weapon_data.cost):
		return
	_spawn_weapon(weapon_data)
	EventBus.item_purchased.emit(weapon_data, weapon_data.cost)
	_refresh_display()

func _spawn_weapon(weapon_data: WeaponData) -> void:
	var pivot: Node2D = _player.get_node_or_null("WeaponPivot")
	if not pivot:
		return
	var combat: Node = _player.get_node_or_null("PlayerCombat")
	if not combat:
		return
	var weapon_scene := preload("res://weapons/weapon_base.tscn")
	var weapon: Node2D = weapon_scene.instantiate()
	weapon.name = weapon_data.weapon_name
	pivot.add_child(weapon)
	weapon.set_weapon_data(weapon_data)
	combat.add_weapon(weapon)

func _get_weapon_count() -> int:
	var pivot: Node = _player.get_node_or_null("WeaponPivot")
	if not pivot:
		return 0
	return pivot.get_child_count()

func _scan_owned_weapons() -> void:
	_owned_weapons.clear()
	var pivot: Node = _player.get_node_or_null("WeaponPivot")
	if not pivot:
		return
	for child in pivot.get_children():
		if child.get("weapon_data"):
			var wd: WeaponData = child.weapon_data
			if wd and wd.weapon_key != "":
				if not _owned_weapons.has(wd.weapon_key):
					_owned_weapons[wd.weapon_key] = 1
				else:
					_owned_weapons[wd.weapon_key] += 1

func _build_upgrades() -> void:
	_clear_grid(upgrades_hbox)
	_add_upgrade("Deployed Slot (+1)", DataBus.max_deployed, 20, "deployed")
	_add_upgrade("Reserve Slot (+1)", DataBus.max_reserve, 25, "reserve")
	_add_upgrade("Item Slot (+1)", DataBus.max_items, 30, "items")
	_add_upgrade("Weapon Slot (+1)", DataBus.max_weapons, 35, "weapons")

func _add_upgrade(name: String, current: int, cost: int, slot_type: String) -> void:
	var slot := _slot_scene.instantiate()
	slot.setup_upgrade(name, current, cost)
	slot.buy_button.pressed.connect(_on_upgrade_buy.bind(slot_type))
	upgrades_hbox.add_child(slot)

func _on_upgrade_buy(slot_type: String) -> void:
	var max_cap: Dictionary = {
		"deployed": 8,
		"reserve": 6,
		"items": 12,
		"weapons": 8,
	}
	var base_cost: Dictionary = {
		"deployed": 20,
		"reserve": 25,
		"items": 30,
		"weapons": 35,
	}
	var cost_increment: int = 15
	var current_cap: int = 0
	match slot_type:
		"deployed": current_cap = DataBus.max_deployed
		"reserve": current_cap = DataBus.max_reserve
		"items": current_cap = DataBus.max_items
		"weapons": current_cap = DataBus.max_weapons
	if current_cap >= max_cap[slot_type]:
		return
	var level: int = current_cap - base_cost[slot_type] / 5
	var cost: int = base_cost[slot_type] + (level * cost_increment)
	if not DataBus.spend_currency(cost):
		return
	match slot_type:
		"deployed": DataBus.max_deployed += 1
		"reserve": DataBus.max_reserve += 1
		"items": DataBus.max_items += 1
		"weapons": DataBus.max_weapons += 1
	EventBus.companion_team_changed.emit()
