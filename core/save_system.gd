extends Node

## SaveSystem - Handles all persistent data storage and retrieval.
## Saves to user:// directory using JSON format.

const SAVE_PATH := "user://save_data.json"
const SETTINGS_PATH := "user://settings.json"

var save_data: Dictionary = {}
var settings: Dictionary = {}

func _ready() -> void:
	_load_save()
	_load_settings()

## Saves all data to disk.
func save() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()

## Loads all data from disk.
func _load_save() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_create_default_save()
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json := JSON.new()
		var error := json.parse(file.get_as_text())
		file.close()
		if error == OK:
			save_data = json.data
		else:
			_create_default_save()

## Creates a default save file with initial values.
func _create_default_save() -> void:
	save_data = {
		"version": "0.1.0",
		"unlocks": {
			"characters": ["default"],
			"weapons": ["pistol"],
			"items": [],
		},
		"statistics": {
			"total_runs": 0,
			"total_kills": 0,
			"total_deaths": 0,
			"total_gold_earned": 0,
			"total_play_time": 0.0,
			"highest_wave": 0,
			"highest_level": 0,
			"total_bosses_defeated": 0,
			"fastest_run": 0.0,
		},
		"achievements": {},
		"highscores": [],
	}
	save()

## Returns the full save data dictionary.
func get_save_data() -> Dictionary:
	return save_data

## Gets a value from save data using a key path.
func get_value(key_path: String, default_value = null):
	var keys := key_path.split("/")
	var current = save_data
	for key in keys:
		if current is Dictionary and current.has(key):
			current = current[key]
		else:
			return default_value
	return current

## Sets a value in save data using a key path.
func set_value(key_path: String, value) -> void:
	var keys := key_path.split("/")
	var current = save_data
	for i in keys.size() - 1:
		if not current.has(keys[i]):
			current[keys[i]] = {}
		current = current[keys[i]]
	current[keys[keys.size() - 1]] = value
	save()

## Adds a new unlock of a specific type.
func add_unlock(unlock_type: String, unlock_id: String) -> void:
	if not save_data.has("unlocks"):
		save_data["unlocks"] = {}
	if not save_data["unlocks"].has(unlock_type):
		save_data["unlocks"][unlock_type] = []
	if unlock_id not in save_data["unlocks"][unlock_type]:
		save_data["unlocks"][unlock_type].append(unlock_id)
		save()

## Checks if an item is unlocked.
func is_unlocked(unlock_type: String, unlock_id: String) -> bool:
	if not save_data.has("unlocks"):
		return false
	if not save_data["unlocks"].has(unlock_type):
		return false
	return unlock_id in save_data["unlocks"][unlock_type]

## Gets all unlocks of a specific type.
func get_unlocks(unlock_type: String) -> Array:
	if save_data.has("unlocks") and save_data["unlocks"].has(unlock_type):
		return save_data["unlocks"][unlock_type]
	return []

## Updates a statistics value by adding to it.
func add_stat(stat_name: String, amount) -> void:
	if not save_data.has("statistics"):
		save_data["statistics"] = {}
	if not save_data["statistics"].has(stat_name):
		save_data["statistics"][stat_name] = 0
	save_data["statistics"][stat_name] += amount
	save()

## Gets a statistics value.
func get_stat(stat_name: String) -> int:
	if save_data.has("statistics") and save_data["statistics"].has(stat_name):
		return save_data["statistics"][stat_name]
	return 0

## Sets an achievement as completed.
func unlock_achievement(achievement_id: String) -> void:
	if not save_data.has("achievements"):
		save_data["achievements"] = {}
	if not save_data["achievements"].has(achievement_id):
		save_data["achievements"][achievement_id] = {
			"unlocked_at": Time.get_unix_time_from_system()
		}
		save()

## Checks if an achievement is unlocked.
func is_achievement_unlocked(achievement_id: String) -> bool:
	return save_data.has("achievements") and save_data["achievements"].has(achievement_id)

## Adds a highscore entry.
func add_highscore(score: Dictionary) -> void:
	if not save_data.has("highscores"):
		save_data["highscores"] = []
	save_data["highscores"].append(score)
	save_data["highscores"].sort_custom(func(a, b): return a.get("score", 0) > b.get("score", 0))
	if save_data["highscores"].size() > 10:
		save_data["highscores"] = save_data["highscores"].slice(0, 10)
	save()

## Deletes all save data.
func delete_save() -> void:
	save_data = {}
	_create_default_save()

## Saves settings to disk.
func save_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(settings, "\t"))
		file.close()

## Loads settings from disk.
func _load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		_create_default_settings()
		return
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if file:
		var json := JSON.new()
		var error := json.parse(file.get_as_text())
		file.close()
		if error == OK:
			settings = json.data
		else:
			_create_default_settings()

## Creates default settings.
func _create_default_settings() -> void:
	settings = {
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"fullscreen": true,
		"vsync": true,
		"screen_shake": true,
		"damage_numbers": true,
	}
	save_settings()

## Gets a setting value.
func get_setting(key: String, default_value = null):
	return settings.get(key, default_value)

## Sets a setting value.
func set_setting(key: String, value) -> void:
	settings[key] = value
	save_settings()
