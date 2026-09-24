class_name WaveData
extends Resource

## Resource that defines the properties of a single wave.

@export var wave_number: int = 1
@export var duration: float = 60.0
@export var enemy_types: Array = ["melee"]
@export var enemy_count: int = 10
@export var spawn_rate: float = 1.0
@export var difficulty_multiplier: float = 1.0
@export var description: String = ""
