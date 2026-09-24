extends Node

## CompanionDatabase - Central database for all companion monsters.

var _companions: Dictionary = {}

func _ready() -> void:
	_register_defaults()

func _register_defaults() -> void:
	_add("slime", _c("Green Slime", CompanionData.CompanionType.GRASS, CompanionData.CombatType.MELEE, 4, 1.2, 70, 2.0, 50, 300, 30, "Bouncy and loyal.", 1, 15))
	_add("spider", _c("Poison Spider", CompanionData.CompanionType.GRASS, CompanionData.CombatType.MELEE, 6, 0.9, 90, 1.5, 55, 280, 60, "Poisonous bites.", 1, 25))
	_add("stone_golem", _c("Stone Golem", CompanionData.CompanionType.GRASS, CompanionData.CombatType.MELEE, 12, 0.5, 60, 1.0, 40, 250, 100, "Slow but devastating.", 1, 45))
	_add("lightning_bug", _c("Lightning Bug", CompanionData.CompanionType.GRASS, CompanionData.CombatType.RANGED, 3, 2.5, 100, 3.0, 65, 400, 20, "Fast and zappy.", 1, 30))
	_add("fire_spirit", _c("Fire Spirit", CompanionData.CompanionType.FIRE, CompanionData.CombatType.RANGED, 8, 1.0, 80, 2.5, 60, 350, 50, "Burns everything.", 1, 20))
	_add("phoenix", _c("Phoenix", CompanionData.CompanionType.FIRE, CompanionData.CombatType.RANGED, 15, 0.7, 100, 1.8, 70, 400, 80, "Reborn in flames.", 1, 70))
	_add("skeleton", _c("Skeleton Warrior", CompanionData.CompanionType.FIRE, CompanionData.CombatType.MELEE, 10, 1.3, 75, 2.2, 55, 320, 70, "Undead fighter.", 1, 40))
	_add("ice_crystal", _c("Ice Crystal", CompanionData.CompanionType.WATER, CompanionData.CombatType.RANGED, 5, 1.5, 90, 2.0, 65, 380, 40, "Freezes on contact.", 1, 18))
	_add("shadow_cat", _c("Shadow Cat", CompanionData.CompanionType.WATER, CompanionData.CombatType.MELEE, 7, 1.8, 85, 3.5, 70, 350, 45, "Sneaky and quick.", 1, 35))
	_add("bat", _c("Vampire Bat", CompanionData.CompanionType.WATER, CompanionData.CombatType.RANGED, 9, 1.4, 95, 2.8, 60, 370, 55, "Drains life force.", 1, 50))

func _add(key: String, companion: CompanionData) -> void:
	companion.companion_key = key
	_companions[key] = companion

func _c(n: String, t: CompanionData.CompanionType, ct: CompanionData.CombatType, dmg: float, spd: float, rng: float, orb_spd: float, orb_dist: float, pspd: float, kb: float, desc: String, ph: int, cost: int) -> CompanionData:
	var c := CompanionData.new()
	c.companion_name = n
	c.companion_type = t
	c.combat_type = ct
	c.base_damage = dmg
	c.attack_speed = spd
	c.attack_range = rng
	c.orbit_speed = orb_spd
	c.orbit_distance = orb_dist
	c.projectile_speed = pspd
	c.knockback = kb
	c.description = desc
	c.phase = ph
	c.cost = cost
	return c

func get_companion(key: String) -> CompanionData:
	return _companions.get(key)

func get_all_companions() -> Dictionary:
	return _companions

func get_companion_keys() -> Array:
	return _companions.keys()

func get_random_companions(count: int, exclude_keys: Array = []) -> Array:
	var available: Array = []
	for key in _companions:
		if key not in exclude_keys:
			available.append(_companions[key])
	available.shuffle()
	return available.slice(0, mini(count, available.size()))
