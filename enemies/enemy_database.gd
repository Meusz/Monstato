extends Node

## EnemyDatabase - Central database for all enemy types.

var _enemies: Dictionary = {}

func _ready() -> void:
	_register_defaults()

func _register_defaults() -> void:
	var melee := EnemyData.new()
	melee.enemy_name = "Melee Grunt"
	melee.health = 30.0
	melee.damage = 8.0
	melee.speed = 80.0
	melee.attack_range = 25.0
	melee.attack_cooldown = 1.0
	melee.xp_value = 10
	melee.element = CompanionData.CompanionType.FIRE
	melee.type = "melee"
	_enemies["melee"] = melee

	var ranged := EnemyData.new()
	ranged.enemy_name = "Ranged Shooter"
	ranged.health = 20.0
	ranged.damage = 5.0
	ranged.speed = 60.0
	ranged.attack_range = 200.0
	ranged.attack_cooldown = 4.0
	ranged.xp_value = 15
	ranged.element = CompanionData.CompanionType.GRASS
	ranged.type = "ranged"
	_enemies["ranged"] = ranged

	var tank := EnemyData.new()
	tank.enemy_name = "Heavy Tank"
	tank.health = 80.0
	tank.armor = 20.0
	tank.damage = 12.0
	tank.speed = 40.0
	tank.attack_range = 30.0
	tank.attack_cooldown = 2.0
	tank.xp_value = 25
	tank.element = CompanionData.CompanionType.WATER
	tank.scale = 1.5
	tank.type = "tank"
	_enemies["tank"] = tank

	var fast := EnemyData.new()
	fast.enemy_name = "Speed Runner"
	fast.health = 15.0
	fast.damage = 4.0
	fast.speed = 180.0
	fast.attack_range = 20.0
	fast.attack_cooldown = 0.5
	fast.xp_value = 8
	fast.element = CompanionData.CompanionType.FIRE
	fast.type = "fast"
	_enemies["fast"] = fast

	var mini_boss := EnemyData.new()
	mini_boss.enemy_name = "Mini Boss"
	mini_boss.health = 200.0
	mini_boss.armor = 10.0
	mini_boss.damage = 20.0
	mini_boss.speed = 70.0
	mini_boss.attack_range = 40.0
	mini_boss.attack_cooldown = 1.5
	mini_boss.xp_value = 100
	mini_boss.element = CompanionData.CompanionType.GRASS
	mini_boss.scale = 2.0
	mini_boss.type = "mini_boss"
	_enemies["mini_boss"] = mini_boss

	var boss := EnemyData.new()
	boss.enemy_name = "Boss"
	boss.health = 500.0
	boss.armor = 30.0
	boss.damage = 30.0
	boss.speed = 60.0
	boss.attack_range = 50.0
	boss.attack_cooldown = 2.0
	boss.xp_value = 500
	boss.element = CompanionData.CompanionType.WATER
	boss.scale = 3.0
	boss.type = "boss"
	_enemies["boss"] = boss

func get_enemy(key: String) -> EnemyData:
	return _enemies.get(key)

func get_all_enemies() -> Dictionary:
	return _enemies

func get_enemy_keys() -> Array:
	return _enemies.keys()

func get_enemies_by_keys(keys: Array) -> Array[EnemyData]:
	var result: Array[EnemyData] = []
	for key in keys:
		if _enemies.has(key):
			result.append(_enemies[key])
	return result
