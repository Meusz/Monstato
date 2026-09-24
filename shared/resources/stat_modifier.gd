class_name StatModifier
extends Resource

## Resource that defines a modification to a stat.

enum ModifierType {
	FLAT,
	PERCENTAGE,
}

enum Stat {
	MAX_HEALTH,
	HEALTH,
	ARMOR,
	SPEED,
	REGENERATION,
	LIFE_STEAL,
	LUCK,
	DAMAGE,
	MELEE_DAMAGE,
	RANGED_DAMAGE,
	ELEMENTAL_DAMAGE,
	CRIT_CHANCE,
	CRIT_MULTIPLIER,
	ATTACK_SPEED,
	ENGINEERING,
	RANGE,
	DODGE,
	HARVESTING,
	CURSE,
	PROJECTILE_COUNT,
	KNOCKBACK_FORCE,
	PICKUP_RANGE,
	XP_BONUS,
	GOLD_BONUS,
}

@export var stat: Stat = Stat.MAX_HEALTH
@export var modifier_type: ModifierType = ModifierType.FLAT
@export var value: float = 0.0
@export var description: String = ""

func apply(stats: Dictionary) -> Dictionary:
	var stat_key := _stat_to_key(stat)
	if not stats.has(stat_key):
		return stats
	match modifier_type:
		ModifierType.FLAT:
			stats[stat_key] += value
		ModifierType.PERCENTAGE:
			stats[stat_key] *= (1.0 + value)
	return stats

func remove(stats: Dictionary) -> Dictionary:
	var stat_key := _stat_to_key(stat)
	if not stats.has(stat_key):
		return stats
	match modifier_type:
		ModifierType.FLAT:
			stats[stat_key] -= value
		ModifierType.PERCENTAGE:
			stats[stat_key] /= (1.0 + value)
	return stats

func _stat_to_key(s: Stat) -> String:
	match s:
		Stat.MAX_HEALTH: return "max_health"
		Stat.HEALTH: return "health"
		Stat.ARMOR: return "armor"
		Stat.SPEED: return "speed"
		Stat.REGENERATION: return "regeneration"
		Stat.LIFE_STEAL: return "life_steal"
		Stat.LUCK: return "luck"
		Stat.DAMAGE: return "damage"
		Stat.MELEE_DAMAGE: return "melee_damage"
		Stat.RANGED_DAMAGE: return "ranged_damage"
		Stat.ELEMENTAL_DAMAGE: return "elemental_damage"
		Stat.CRIT_CHANCE: return "crit_chance"
		Stat.CRIT_MULTIPLIER: return "crit_multiplier"
		Stat.ATTACK_SPEED: return "attack_speed"
		Stat.ENGINEERING: return "engineering"
		Stat.RANGE: return "range"
		Stat.DODGE: return "dodge"
		Stat.HARVESTING: return "harvesting"
		Stat.CURSE: return "curse"
		Stat.PROJECTILE_COUNT: return "projectile_count"
		Stat.KNOCKBACK_FORCE: return "knockback_force"
		Stat.PICKUP_RANGE: return "pickup_range"
		Stat.XP_BONUS: return "xp_bonus"
		Stat.GOLD_BONUS: return "gold_bonus"
	return ""

func get_description() -> String:
	if description != "":
		return description
	var stat_name := _stat_to_key(stat).replace("_", " ").capitalize()
	match modifier_type:
		ModifierType.FLAT:
			return "+%.1f %s" % [value, stat_name]
		ModifierType.PERCENTAGE:
			return "+%d%% %s" % [int(value * 100), stat_name]
	return ""
