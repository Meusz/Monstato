extends Node

## Main scene controller. Entry point of the game.
## Loads the main menu on startup and manages scene transitions.

func _ready() -> void:
	_setup_audio_buses()
	_load_main_menu()

func _setup_audio_buses() -> void:
	if AudioServer.get_bus_index("Music") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, "Music")
	if AudioServer.get_bus_index("SFX") == -1:
		AudioServer.add_bus()
		AudioServer.set_bus_name(AudioServer.bus_count - 1, "SFX")

func _load_main_menu() -> void:
	_load_scene("res://ui/main_menu/main_menu.tscn")

func _load_scene(scene_path: String) -> void:
	if ResourceLoader.exists(scene_path):
		get_tree().call_deferred("change_scene_to_file", scene_path)
	else:
		push_warning("Main: Scene not found: %s" % scene_path)
