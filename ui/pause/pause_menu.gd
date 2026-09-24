extends CanvasLayer

## PauseMenu - Overlay shown when game is paused.

@onready var resume_button: Button = $CenterContainer/VBoxContainer/ResumeButton
@onready var settings_button: Button = $CenterContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton

var settings_ui: CanvasLayer = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	resume_button.pressed.connect(_on_resume)
	settings_button.pressed.connect(_on_settings)
	quit_button.pressed.connect(_on_quit)
	EventBus.game_paused.connect(_on_game_paused)

func _on_game_paused(paused: bool) -> void:
	visible = paused

func _on_resume() -> void:
	GameManager.toggle_pause()

func _on_settings() -> void:
	visible = false
	if settings_ui:
		settings_ui.show_settings()

func _on_quit() -> void:
	get_tree().paused = false
	GameManager.is_paused = false
	GameManager.change_state(GameManager.GameState.MAIN_MENU)
	EventBus.scene_change_requested.emit("res://ui/main_menu/main_menu.tscn")
