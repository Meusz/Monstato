extends Node

## AudioManager - Central audio management system.
## Handles music, SFX, and bus volume control.

var _music_players: Array[AudioStreamPlayer] = []
var _sfx_pool: Array[AudioStreamPlayer] = []
var _current_music_track: String = ""

const SFX_POOL_SIZE := 16
const MUSIC_FADE_DURATION := 1.0

var _music_volume: float = 1.0
var _sfx_volume: float = 1.0
var _master_volume: float = 1.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_create_music_player()
	_create_sfx_pool()
	_load_volume_settings()
	EventBus.sfx_requested.connect(play_sfx)
	EventBus.music_requested.connect(play_music)
	EventBus.music_stop_requested.connect(stop_music)
	EventBus.volume_changed.connect(_on_volume_changed)

func _create_music_player() -> void:
	var player := AudioStreamPlayer.new()
	player.bus = "Music"
	player.name = "MusicPlayer"
	add_child(player)
	_music_players.append(player)

func _create_sfx_pool() -> void:
	for i in SFX_POOL_SIZE:
		var player := AudioStreamPlayer.new()
		player.bus = "SFX"
		player.name = "SFXPlayer_%d" % i
		add_child(player)
		_sfx_pool.append(player)

## Plays a music track by name. Loads from res://assets/audio/music/.
func play_music(track_name: String) -> void:
	if track_name == _current_music_track:
		return
	_current_music_track = track_name
	var path := "res://assets/audio/music/%s.ogg" % track_name
	if not ResourceLoader.exists(path):
		path = "res://assets/audio/music/%s.wav" % track_name
	if not ResourceLoader.exists(path):
		push_warning("AudioManager: Music track not found: %s" % track_name)
		return
	var stream = load(path)
	var player := _music_players[0]
	player.stream = stream
	player.play()

## Stops the currently playing music.
func stop_music() -> void:
	_current_music_track = ""
	if _music_players.size() > 0:
		_music_players[0].stop()

## Plays an SFX by name. Loads from res://assets/audio/sfx/.
func play_sfx(sfx_name: String) -> void:
	var path := "res://assets/audio/sfx/%s.wav" % sfx_name
	if not ResourceLoader.exists(path):
		path = "res://assets/audio/sfx/%s.ogg" % sfx_name
	if not ResourceLoader.exists(path):
		push_warning("AudioManager: SFX not found: %s" % sfx_name)
		return
	var stream = load(path)
	var player := _get_free_sfx_player()
	if player:
		player.stream = stream
		player.play()

## Returns an available SFX player from the pool.
func _get_free_sfx_player() -> AudioStreamPlayer:
	for player in _sfx_pool:
		if not player.playing:
			return player
	return _sfx_pool[0]

## Sets volume for a specific bus.
func set_bus_volume(bus_name: String, volume: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return
	var db := linear_to_db(clampf(volume, 0.0, 1.0))
	AudioServer.set_bus_volume_db(bus_index, db)
	match bus_name:
		"Master":
			_master_volume = volume
		"Music":
			_music_volume = volume
		"SFX":
			_sfx_volume = volume
	_save_volume_settings()

## Gets volume for a specific bus.
func get_bus_volume(bus_name: String) -> float:
	match bus_name:
		"Master":
			return _master_volume
		"Music":
			return _music_volume
		"SFX":
			return _sfx_volume
	return 1.0

## Mutes or unmutes a bus.
func set_bus_mute(bus_name: String, muted: bool) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_mute(bus_index, muted)

func _on_volume_changed(bus_name: String, volume: float) -> void:
	set_bus_volume(bus_name, volume)

func _save_volume_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("audio", "master", _master_volume)
	config.set_value("audio", "music", _music_volume)
	config.set_value("audio", "sfx", _sfx_volume)
	config.save("user://audio_settings.cfg")

func _load_volume_settings() -> void:
	var config := ConfigFile.new()
	if config.load("user://audio_settings.cfg") == OK:
		set_bus_volume("Master", config.get_value("audio", "master", 1.0))
		set_bus_volume("Music", config.get_value("audio", "music", 1.0))
		set_bus_volume("SFX", config.get_value("audio", "sfx", 1.0))
