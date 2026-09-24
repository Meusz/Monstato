extends CanvasLayer

## HUD - Heads-Up Display during gameplay.

@onready var health_bar: ProgressBar = $MarginContainer/VBoxContainer/TopBar/HealthBar
@onready var health_label: Label = $MarginContainer/VBoxContainer/TopBar/HealthBar/HealthLabel
@onready var wave_label: Label = $MarginContainer/VBoxContainer/TopBar/WaveLabel
@onready var timer_label: Label = $MarginContainer/VBoxContainer/TopBar/TimerLabel
@onready var currency_label: Label = $MarginContainer/VBoxContainer/TopBar/CurrencyLabel
@onready var enemy_count_label: Label = $MarginContainer/VBoxContainer/TopBar/EnemyCountLabel
@onready var xp_bar: ProgressBar = $MarginContainer/VBoxContainer/TopBar/XPBar
@onready var xp_label: Label = $MarginContainer/VBoxContainer/TopBar/XPBar/XPLabel
@onready var level_label: Label = $MarginContainer/VBoxContainer/TopBar/LevelLabel
@onready var dash_cooldown_bar: ProgressBar = $MarginContainer/VBoxContainer/CooldownsSection/DashCooldownBar
@onready var dash_label: Label = $MarginContainer/VBoxContainer/CooldownsSection/DashCooldownBar/DashLabel
@onready var ability_cooldown_bar: ProgressBar = $MarginContainer/VBoxContainer/CooldownsSection/AbilityCooldownBar
@onready var ability_label: Label = $MarginContainer/VBoxContainer/CooldownsSection/AbilityCooldownBar/AbilityLabel

var _companion_xp_label: String = ""

func _ready() -> void:
	_connect_signals()
	_update_all()

func _connect_signals() -> void:
	EventBus.player_damaged.connect(_on_player_damaged)
	EventBus.player_healed.connect(_on_player_healed)
	EventBus.currency_changed.connect(_on_currency_changed)
	EventBus.wave_started.connect(_on_wave_started)
	EventBus.wave_timer_updated.connect(_on_wave_timer_updated)
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.enemy_spawned.connect(_on_enemy_spawned)
	EventBus.companion_leveled_up.connect(_on_companion_leveled_up)

func _process(_delta: float) -> void:
	_update_health_bar()
	_update_cooldowns()

func _update_cooldowns() -> void:
	var player := GameManager.get_player()
	if not player:
		return
	var dash_node = player.get_node_or_null("DashAbility")
	if dash_node and dash_node.has_method("is_on_cooldown"):
		var remaining: float = dash_node.get_cooldown_remaining() if dash_node.has_method("get_cooldown_remaining") else 0.0
		dash_cooldown_bar.max_value = 0.8
		dash_cooldown_bar.value = maxf(0, remaining)
		if remaining > 0:
			dash_label.text = "DASH %.1fs" % remaining
		else:
			dash_label.text = "DASH READY"

	var ability_node = player.get_node_or_null("TrainerAbility")
	if ability_node and ability_node.has_method("is_on_cooldown"):
		var remaining: float = ability_node.get_cooldown_remaining() if ability_node.has_method("get_cooldown_remaining") else 0.0
		var total: float = ability_node.get_cooldown_total() if ability_node.has_method("get_cooldown_total") else 8.0
		ability_cooldown_bar.max_value = total
		ability_cooldown_bar.value = maxf(0, remaining)
		if remaining > 0:
			ability_label.text = "ABILITY %.1fs" % remaining
		else:
			ability_label.text = "ABILITY READY"

func _update_all() -> void:
	_update_health_bar()
	_update_currency()
	_update_xp_bar()
	wave_label.text = "Wave: %d" % DataBus.current_wave
	_update_companion_info()

func _update_health_bar() -> void:
	var current: float = DataBus.player_stats.get("health", 100.0)
	var max_h: float = DataBus.player_stats.get("max_health", 100.0)
	health_bar.max_value = max_h
	health_bar.value = current
	health_label.text = "%d / %d" % [int(current), int(max_h)]

func _update_xp_bar() -> void:
	var player := GameManager.get_player()
	if not player:
		return
	for child in player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			var d: CompanionData = child.companion_data
			xp_bar.max_value = d.xp_to_next
			xp_bar.value = d.xp
			xp_label.text = "%s XP: %d/%d" % [d.companion_name.left(6), d.xp, d.xp_to_next]
			return
	xp_bar.max_value = 1
	xp_bar.value = 0
	xp_label.text = ""

func _update_currency() -> void:
	currency_label.text = "$%d" % DataBus.currency

func _on_player_damaged(_amount: float, _source: Node) -> void:
	_update_health_bar()

func _on_player_healed(_amount: float) -> void:
	_update_health_bar()

func _on_currency_changed(_amount: int) -> void:
	_update_currency()

func _on_wave_started(wave_number: int) -> void:
	wave_label.text = "Wave: %d" % wave_number

func _on_wave_timer_updated(time_remaining: float) -> void:
	var minutes := int(time_remaining) / 60
	var seconds := int(time_remaining) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _on_enemy_killed(_enemy: Node, _xp: int) -> void:
	enemy_count_label.text = "Enemies: %d" % GameManager.get_enemy_count()

func _on_enemy_spawned(_enemy: Node) -> void:
	enemy_count_label.text = "Enemies: %d" % GameManager.get_enemy_count()

func _on_companion_leveled_up(companion_name: String, new_level: int) -> void:
	level_label.text = "%s Lv.%d" % [companion_name.left(8), new_level]

func _update_companion_info() -> void:
	var player := GameManager.get_player()
	if not player:
		return
	for child in player.get_children():
		if child.has_method("set_companion_data") and child.companion_data:
			var d: CompanionData = child.companion_data
			level_label.text = "%s Ph.%d Lv.%d" % [d.companion_name.left(6), d.phase, d.level]
			return
	level_label.text = "No companions"
