class_name CompanionData
extends Resource

## Resource that defines a companion monster's properties.

enum CompanionType { GRASS, FIRE, WATER }
enum CombatType { MELEE, RANGED }
enum ElementEffect { NONE, BURN, POISON, FREEZE, BLEED, SHIELD, LIFESTEAL }

@export var companion_name: String = "Companion"
@export var companion_type: CompanionType = CompanionType.GRASS
@export var combat_type: CombatType = CombatType.MELEE
@export var base_damage: float = 5.0
@export var attack_speed: float = 1.0
@export var attack_range: float = 80.0
@export var orbit_speed: float = 2.0
@export var orbit_distance: float = 60.0
@export var projectile_speed: float = 300.0
@export var knockback: float = 50.0
@export var description: String = ""
@export var phase: int = 1
@export var cost: int = 15
@export var companion_key: String = ""

## Elemental effect on hit
@export var element_effect: ElementEffect = ElementEffect.NONE
@export var effect_chance: float = 0.0
@export var effect_damage: float = 0.0
@export var effect_duration: float = 0.0

## Passive bonuses for the player (when deployed)
@export var player_xp_bonus: float = 0.0
@export var player_shield: float = 0.0
@export var player_life_steal: float = 0.0
@export var player_damage_bonus: float = 0.0
@export var player_speed_bonus: float = 0.0

var xp: int = 0
var level: int = 1
var xp_to_next: int = 10

func add_xp(amount: int) -> bool:
	xp += amount
	var leveled: bool = false
	while xp >= xp_to_next:
		xp -= xp_to_next
		level += 1
		xp_to_next = int(10 * pow(level, 1.5))
		leveled = true
	return leveled

func get_level_color() -> Color:
	match level:
		1: return Color(0.6, 0.6, 0.6)
		2: return Color(0.2, 0.8, 0.2)
		3: return Color(0.2, 0.4, 1.0)
		4: return Color(1.0, 0.8, 0.0)
	return Color(0.9, 0.9, 0.9)

func get_phase_color() -> Color:
	match phase:
		1: return Color(0.6, 0.6, 0.6)
		2: return Color(0.2, 0.8, 0.2)
		3: return Color(0.2, 0.4, 1.0)
		4: return Color(1.0, 0.8, 0.0)
	return Color.WHITE

func get_phase_name() -> String:
	return "Phase %d" % phase

func get_type_name() -> String:
	match companion_type:
		CompanionType.GRASS: return "Grass"
		CompanionType.FIRE: return "Fire"
		CompanionType.WATER: return "Water"
	return ""

func get_type_color() -> Color:
	match companion_type:
		CompanionType.GRASS: return Color(0.18, 0.8, 0.44)
		CompanionType.FIRE: return Color(0.91, 0.3, 0.24)
		CompanionType.WATER: return Color(0.2, 0.6, 0.86)
	return Color.WHITE

func get_effect_name() -> String:
	match element_effect:
		ElementEffect.BURN: return "Burn"
		ElementEffect.POISON: return "Poison"
		ElementEffect.FREEZE: return "Freeze"
		ElementEffect.BLEED: return "Bleed"
		ElementEffect.SHIELD: return "Shield+"
		ElementEffect.LIFESTEAL: return "Lifesteal+"
	return ""

func get_effect_color() -> Color:
	match element_effect:
		ElementEffect.BURN: return Color(0.9, 0.4, 0.1)
		ElementEffect.POISON: return Color(0.4, 0.8, 0.2)
		ElementEffect.FREEZE: return Color(0.3, 0.7, 1.0)
		ElementEffect.BLEED: return Color(0.8, 0.1, 0.1)
		ElementEffect.SHIELD: return Color(0.3, 0.6, 1.0)
		ElementEffect.LIFESTEAL: return Color(0.8, 0.2, 0.5)
	return Color.WHITE

## Returns damage multiplier when this companion attacks a target of defender_type.
func get_type_multiplier(defender_type: CompanionType) -> float:
	match companion_type:
		CompanionType.GRASS:
			if defender_type == CompanionType.WATER:
				return 2.0
			if defender_type == CompanionType.FIRE:
				return 0.5
		CompanionType.FIRE:
			if defender_type == CompanionType.GRASS:
				return 2.0
			if defender_type == CompanionType.WATER:
				return 0.5
		CompanionType.WATER:
			if defender_type == CompanionType.FIRE:
				return 2.0
			if defender_type == CompanionType.GRASS:
				return 0.5
	return 1.0

func get_upgraded(new_phase: int) -> CompanionData:
	var upgraded := CompanionData.new()
	upgraded.companion_name = companion_name
	upgraded.companion_type = companion_type
	upgraded.combat_type = combat_type
	upgraded.base_damage = base_damage * (1.0 + 0.5 * new_phase)
	upgraded.attack_speed = attack_speed * (1.0 + 0.15 * new_phase)
	upgraded.attack_range = attack_range * (1.0 + 0.1 * new_phase)
	upgraded.orbit_speed = orbit_speed
	upgraded.orbit_distance = orbit_distance * (1.0 + 0.35 * (new_phase - 1))
	upgraded.projectile_speed = projectile_speed
	upgraded.knockback = knockback + 15.0 * new_phase
	upgraded.description = description
	upgraded.phase = new_phase
	upgraded.cost = int(cost * (1.5 + 0.5 * new_phase))
	upgraded.companion_key = companion_key
	upgraded.element_effect = element_effect
	upgraded.effect_chance = mini(100, effect_chance + 10 * new_phase)
	upgraded.effect_damage = effect_damage * (1.0 + 0.3 * new_phase)
	upgraded.effect_duration = effect_duration + 0.5 * new_phase
	upgraded.player_xp_bonus = player_xp_bonus * (1.0 + 0.2 * new_phase)
	upgraded.player_shield = player_shield + 2.0 * new_phase
	upgraded.player_life_steal = player_life_steal + 0.5 * new_phase
	upgraded.player_damage_bonus = player_damage_bonus + 1.0 * new_phase
	upgraded.player_speed_bonus = player_speed_bonus + 1.0 * new_phase
	return upgraded

func get_sell_value() -> int:
	return int(cost * 0.5)

func get_stats_text() -> String:
	var lines: PackedStringArray = []
	lines.append("DMG: %d" % int(base_damage))
	lines.append("SPD: %.1f" % attack_speed)
	lines.append("RNG: %d" % int(attack_range))
	if element_effect != ElementEffect.NONE:
		lines.append("Effect: %s (%d%%)" % [get_effect_name(), int(effect_chance)])
		if effect_damage > 0:
			lines.append("  DMG/tick: %d" % int(effect_damage))
	if player_xp_bonus > 0:
		lines.append("XP Bonus: +%.0f%%" % player_xp_bonus)
	if player_shield > 0:
		lines.append("Shield: +%.0f" % player_shield)
	if player_life_steal > 0:
		lines.append("Life Steal: +%.0f%%" % player_life_steal)
	if player_damage_bonus > 0:
		lines.append("DMG Bonus: +%.0f%%" % player_damage_bonus)
	if player_speed_bonus > 0:
		lines.append("SPD Bonus: +%.0f%%" % player_speed_bonus)
	return "\n".join(lines)
