extends Control

## Main menu scene. First screen the player sees.

var _settings_ui: PackedScene = preload("res://ui/settings/settings_ui.tscn")

func _ready() -> void:
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_settings_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

func _on_play_pressed() -> void:
	EventBus.scene_change_requested.emit("res://ui/character_select/character_select.tscn")

func _on_settings_pressed() -> void:
	var settings = _settings_ui.instantiate()
	add_child(settings)
	settings.show_settings()

func _on_quit_pressed() -> void:
	get_tree().quit()
