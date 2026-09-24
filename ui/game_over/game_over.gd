extends CanvasLayer

## GameOverScreen - Shows game over with death reason and stats.

@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel
@onready var death_label: Label = $PanelContainer/VBoxContainer/DeathLabel
@onready var stats_label: Label = $PanelContainer/VBoxContainer/StatsLabel
@onready var wave_label: Label = $PanelContainer/VBoxContainer/WaveLabel
@onready var time_label: Label = $PanelContainer/VBoxContainer/TimeLabel
@onready var revive_hbox: HBoxContainer = $PanelContainer/VBoxContainer/ReviveHBox
@onready var revive_button: Button = $PanelContainer/VBoxContainer/ReviveHBox/ReviveButton
@onready var return_button: Button = $PanelContainer/VBoxContainer/ReturnButton

var rewarded_ad_panel: CanvasLayer = null
var was_revived: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	EventBus.game_over.connect(_on_game_over)
	EventBus.player_revived.connect(_on_player_revived)
	return_button.pressed.connect(_on_return_pressed)
	revive_button.pressed.connect(_on_revive_pressed)

var _visible_before_game_over: bool = false

func _on_game_over(victory: bool) -> void:
	was_revived = false
	_visible_before_game_over = visible
	visible = true
	if victory:
		title_label.text = "VICTORY!"
		title_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2))
		death_label.text = ""
		revive_hbox.visible = false
	else:
		title_label.text = "GAME OVER"
		title_label.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))
		var reason: String = DataBus.death_reason if DataBus.death_reason != "" else "You have fallen"
		death_label.text = reason
		revive_hbox.visible = true
	_update_stats()
	get_tree().paused = true

func _update_stats() -> void:
	var s: Dictionary = DataBus.run_stats
	wave_label.text = "Waves survived: %d" % s.get("total_waves_survived", 0)
	var t: float = GameManager.get_run_time()
	time_label.text = "Time: %02d:%02d" % [int(t) / 60, int(t) % 60]
	var kills: int = s.get("total_kills", 0)
	var gold: int = s.get("total_gold_earned", 0)
	var dmg: float = s.get("total_damage_dealt", 0.0)
	stats_label.text = "Kills: %d | Gold: %d | Damage: %d" % [kills, gold, int(dmg)]

func _on_revive_pressed() -> void:
	if was_revived:
		print("[GameOver] Already revived - cannot revive again")
		return
	visible = false
	_get_rewarded_ad_panel().show_revive_prompt()

func _get_rewarded_ad_panel() -> CanvasLayer:
	if not rewarded_ad_panel or not is_instance_valid(rewarded_ad_panel):
		for child in get_parent().get_children():
			if child is CanvasLayer and child.name == "RewardedAdPanel":
				rewarded_ad_panel = child
				break
	if not rewarded_ad_panel:
		rewarded_ad_panel = preload("res://ui/rewarded_ad/rewarded_ad_panel.tscn").instantiate()
		rewarded_ad_panel.name = "RewardedAdPanel"
		get_parent().add_child(rewarded_ad_panel)
	return rewarded_ad_panel

func _on_player_revived() -> void:
	was_revived = true
	var player: Node = GameManager.get_player()
	if not player:
		print("[GameOver] No player found to revive")
		visible = true
		return
	var health_comp: HealthComponent = player.get_node_or_null("HealthComponent")
	if not health_comp:
		print("[GameOver] No HealthComponent on player")
		visible = true
		return
	var max_hp: float = health_comp.max_health
	var revive_hp: float = max_hp * 0.3
	health_comp.current_health = revive_hp
	health_comp._is_dead = false
	health_comp._is_invincible = true
	health_comp._invincibility_timer = 2.0
	health_comp.health_changed.emit(health_comp.current_health, health_comp.max_health)
	DataBus.player_stats["health"] = revive_hp
	EventBus.player_healed.emit(revive_hp)
	# Stop any active wave and clear enemies before prep
	var arena := get_node_or_null("/root/Arena")
	if arena:
		var spawner = arena.get_node_or_null("EnemySpawner")
		if spawner and spawner.has_method("stop_spawning"):
			spawner.stop_spawning()
		var wave_mgr = arena.get_node_or_null("WaveManager")
		if wave_mgr and wave_mgr.has_method("_end_wave"):
			wave_mgr._end_wave()
	GameManager.change_state(GameManager.GameState.WAVE_PREP)
	get_tree().paused = false
	print("[GameOver] Player revived, resuming wave")

func _on_return_pressed() -> void:
	get_tree().paused = false
	visible = false
	EventBus.scene_change_requested.emit("res://ui/main_menu/main_menu.tscn")
