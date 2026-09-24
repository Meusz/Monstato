extends Node

## TrainerAbilities - Autoload that registers and provides all trainer abilities.

var _abilities: Dictionary = {}

func _ready() -> void:
	register_abilities()

func register_abilities() -> void:
	_abilities.clear()

	# Warrior - Whirlwind
	var whirlwind: AbilityData = AbilityData.new()
	whirlwind.ability_name = "Whirlwind"
	whirlwind.ability_key = "whirlwind"
	whirlwind.description = "Spins a devastating whirlwind, damaging all nearby enemies."
	whirlwind.cooldown = 8.0
	whirlwind.damage_multiplier = 0.8
	whirlwind.radius = 150.0
	whirlwind.duration = 0.0
	whirlwind.ability_type = AbilityData.AbilityType.AOE
	_abilities["Warrior"] = whirlwind

	# Ranger - Snipe
	var snipe: AbilityData = AbilityData.new()
	snipe.ability_name = "Snipe"
	snipe.ability_key = "snipe"
	snipe.description = "Fires a cone of precise shots at the nearest enemy."
	snipe.cooldown = 12.0
	snipe.damage_multiplier = 1.5
	snipe.radius = 0.0
	snipe.duration = 0.0
	snipe.ability_type = AbilityData.AbilityType.PROJECTILE
	_abilities["Ranger"] = snipe

	# Tank - Fortify
	var fortify: AbilityData = AbilityData.new()
	fortify.ability_name = "Fortify"
	fortify.ability_key = "fortify"
	fortify.description = "Strengthens armor and reduces incoming damage temporarily."
	fortify.cooldown = 15.0
	fortify.damage_multiplier = 0.0
	fortify.radius = 0.0
	fortify.duration = 5.0
	fortify.ability_type = AbilityData.AbilityType.BUFF
	_abilities["Tank"] = fortify

	# Mage - Elemental Blast
	var elemental_blast: AbilityData = AbilityData.new()
	elemental_blast.ability_name = "Elemental Blast"
	elemental_blast.ability_key = "elemental_blast"
	elemental_blast.description = "Detonates elemental energy, destroying all enemies in range."
	elemental_blast.cooldown = 10.0
	elemental_blast.damage_multiplier = 2.0
	elemental_blast.radius = 200.0
	elemental_blast.duration = 0.0
	elemental_blast.ability_type = AbilityData.AbilityType.BURST
	_abilities["Mage"] = elemental_blast

func get_ability(character_name: String) -> AbilityData:
	return _abilities.get(character_name, null)

func get_all_abilities() -> Dictionary:
	return _abilities

func has_ability(character_name: String) -> bool:
	return _abilities.has(character_name)
