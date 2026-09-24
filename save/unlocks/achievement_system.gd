extends Node

## AchievementSystem - Tracks and unlocks achievements.

var _achievements: Dictionary = {}

func _ready() -> void:
	_register_achievements()
	EventBus.enemy_killed.connect(_on_enemy_killed)
	EventBus.player_leveled_up.connect(_on_player_leveled_up)
	EventBus.wave_completed.connect(_on_wave_completed)
	EventBus.boss_defeated.connect(_on_boss_defeated)
	EventBus.item_purchased.connect(_on_item_purchased)

func _register_achievements() -> void:
	_add_achievement("first_blood", "First Blood", "Kill your first enemy")
	_add_achievement("monster_slayer", "Monster Slayer", "Kill 100 enemies")
	_add_achievement("wave_survivor", "Wave Survivor", "Survive 5 waves")
	_add_achievement("wave_master", "Wave Master", "Survive 10 waves")
	_add_achievement("level_up", "Level Up!", "Reach level 5")
	_add_achievement("high_level", "Veteran", "Reach level 10")
	_add_achievement("boss_slayer", "Boss Slayer", "Defeat a boss")
	_add_achievement("shopaholic", "Shopaholic", "Buy 10 items")
	_add_achievement("rich", "Rich", "Accumulate 500 gold in a run")

func _add_achievement(id: String, name: String, desc: String) -> void:
	_achievements[id] = {
		"name": name,
		"description": desc,
		"unlocked": false
	}

func _check_achievement(id: String) -> void:
	if _achievements.has(id) and not _achievements[id]["unlocked"]:
		_achievements[id]["unlocked"] = true
		SaveSystem.unlock_achievement(id)

func _on_enemy_killed(_enemy: Node, _xp: int) -> void:
	SaveSystem.add_stat("total_kills", 1)
	var kills := SaveSystem.get_stat("total_kills")
	if kills >= 1:
		_check_achievement("first_blood")
	if kills >= 100:
		_check_achievement("monster_slayer")

func _on_player_leveled_up(new_level: int) -> void:
	if new_level >= 5:
		_check_achievement("level_up")
	if new_level >= 10:
		_check_achievement("high_level")

func _on_wave_completed(wave_number: int) -> void:
	if wave_number >= 5:
		_check_achievement("wave_survivor")
	if wave_number >= 10:
		_check_achievement("wave_master")

func _on_boss_defeated(_boss: Node) -> void:
	_check_achievement("boss_slayer")

func _on_item_purchased(_item: Resource, _cost: int) -> void:
	SaveSystem.add_stat("total_items_collected", 1)
	var purchases := SaveSystem.get_stat("total_items_collected")
	if purchases >= 10:
		_check_achievement("shopaholic")

func get_achievements() -> Dictionary:
	return _achievements

func get_achievement(id: String) -> Dictionary:
	return _achievements.get(id, {})

func is_unlocked(id: String) -> bool:
	return _achievements.get(id, {}).get("unlocked", false)
