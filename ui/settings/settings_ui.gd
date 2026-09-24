extends CanvasLayer

## SettingsUI - Volume controls and info.

@onready var master_slider: HSlider = $CenterContainer/VBoxContainer/Master/MasterSlider
@onready var music_slider: HSlider = $CenterContainer/VBoxContainer/Music/MusicSlider
@onready var sfx_slider: HSlider = $CenterContainer/VBoxContainer/SFX/SFXSlider
@onready var back_button: Button = $CenterContainer/VBoxContainer/BackButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	master_slider.value_changed.connect(_on_master_changed)
	music_slider.value_changed.connect(_on_music_changed)
	sfx_slider.value_changed.connect(_on_sfx_changed)
	back_button.pressed.connect(_on_back)

func show_settings() -> void:
	master_slider.value = AudioManager.get_bus_volume("Master")
	music_slider.value = AudioManager.get_bus_volume("Music")
	sfx_slider.value = AudioManager.get_bus_volume("SFX")
	visible = true

func _on_master_changed(value: float) -> void:
	AudioManager.set_bus_volume("Master", value)

func _on_music_changed(value: float) -> void:
	AudioManager.set_bus_volume("Music", value)

func _on_sfx_changed(value: float) -> void:
	AudioManager.set_bus_volume("SFX", value)

func _on_back() -> void:
	visible = false
