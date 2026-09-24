class_name WeaponData
extends Resource

## Resource that defines weapon properties.

@export var weapon_name: String = "Weapon"
@export var base_damage: float = 10.0
@export var attack_speed: float = 1.0
@export var attack_range: float = 150.0
@export var projectile_count: int = 1
@export var projectile_speed: float = 400.0
@export var projectile_pierce: int = 0
@export var spread: float = 0.0
@export var knockback: float = 100.0
@export var color: Color = Color.WHITE
@export var description: String = ""
@export var rarity: Rarity.Tier = Rarity.Tier.COMMON
@export var cost: int = 20
@export var weapon_key: String = ""

func get_rarity_color() -> Color:
	return Rarity.get_color(rarity)

func get_rarity_name() -> String:
	return Rarity.get_tier_name(rarity)

func get_upgraded(level: int) -> WeaponData:
	var upgraded := WeaponData.new()
	upgraded.weapon_name = weapon_name + " +" + str(level)
	upgraded.base_damage = base_damage * (1.0 + 0.25 * level)
	upgraded.attack_speed = attack_speed * (1.0 + 0.1 * level)
	upgraded.attack_range = attack_range * (1.0 + 0.05 * level)
	upgraded.projectile_count = projectile_count + (level / 2)
	upgraded.projectile_speed = projectile_speed
	upgraded.projectile_pierce = projectile_pierce + (level / 3)
	upgraded.spread = spread
	upgraded.knockback = knockback + 20.0 * level
	upgraded.color = color
	upgraded.description = description
	upgraded.rarity = mini(rarity + level / 2, Rarity.Tier.LEGENDARY)
	upgraded.cost = int(cost * (1.5 + 0.5 * level))
	upgraded.weapon_key = weapon_key
	return upgraded
