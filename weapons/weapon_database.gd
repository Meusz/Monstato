extends Node

## WeaponDatabase - Central database for all weapon types.

var _weapons: Dictionary = {}

func _ready() -> void:
	_register_defaults()

func _register_defaults() -> void:
	_add("pistol", _w("Pistol", 10, 2.0, 200, 1, 0, 0, 400, 100, Color(0.8, 0.8, 0.8), "A reliable sidearm.", Rarity.Tier.COMMON, 15))
	_add("shotgun", _w("Shotgun", 8, 1.0, 120, 5, 30, 0, 350, 120, Color(0.6, 0.3, 0.1), "Fires multiple pellets.", Rarity.Tier.COMMON, 25))
	_add("rifle", _w("Rifle", 12, 3.0, 250, 1, 0, 0, 500, 80, Color(0.3, 0.3, 0.3), "Fast-firing automatic.", Rarity.Tier.UNCOMMON, 30))
	_add("laser", _w("Laser", 15, 1.5, 300, 1, 0, 3, 600, 100, Color(0.2, 0.8, 1.0), "Pierces through enemies.", Rarity.Tier.UNCOMMON, 40))
	_add("smg", _w("SMG", 6, 5.0, 160, 1, 0, 0, 450, 80, Color(0.5, 0.5, 0.5), "High fire rate.", Rarity.Tier.COMMON, 20))
	_add("rocket", _w("Rocket Launcher", 40, 0.5, 200, 1, 0, 0, 300, 200, Color(0.8, 0.3, 0.1), "Devastating slow shots.", Rarity.Tier.RARE, 60))
	_add("sniper", _w("Sniper", 35, 0.8, 400, 1, 0, 0, 800, 150, Color(0.1, 0.1, 0.4), "Extreme range.", Rarity.Tier.RARE, 55))
	_add("dual_pistol", _w("Dual Pistols", 8, 2.5, 180, 2, 10, 0, 420, 90, Color(0.9, 0.9, 0.7), "Two reliable sidearms.", Rarity.Tier.UNCOMMON, 35))
	_add("scatter", _w("Scatter Gun", 5, 0.8, 100, 8, 45, 0, 300, 180, Color(0.7, 0.5, 0.2), "Wide spread, close range.", Rarity.Tier.RARE, 50))
	_add("plasma", _w("Plasma Cannon", 25, 1.0, 350, 1, 0, 5, 550, 120, Color(0.3, 1.0, 0.5), "Accurate energy weapon.", Rarity.Tier.EPIC, 80))

func _add(key: String, weapon: WeaponData) -> void:
	weapon.weapon_key = key
	_weapons[key] = weapon

func _w(n: String, dmg: float, spd: float, rng: float, proj: int, spread: float, pierce: int, pspd: float, kb: float, col: Color, desc: String, rar: Rarity.Tier, cost: int) -> WeaponData:
	var w := WeaponData.new()
	w.weapon_name = n
	w.base_damage = dmg
	w.attack_speed = spd
	w.attack_range = rng
	w.projectile_count = proj
	w.spread = spread
	w.projectile_pierce = pierce
	w.projectile_speed = pspd
	w.knockback = kb
	w.color = col
	w.description = desc
	w.rarity = rar
	w.cost = cost
	return w

func get_weapon(key: String) -> WeaponData:
	return _weapons.get(key)

func get_all_weapons() -> Dictionary:
	return _weapons

func get_weapon_keys() -> Array:
	return _weapons.keys()

func get_random_weapons(count: int, exclude_keys: Array = []) -> Array:
	var available: Array = []
	for key in _weapons:
		if key not in exclude_keys:
			available.append(_weapons[key])
	available.shuffle()
	return available.slice(0, mini(count, available.size()))
