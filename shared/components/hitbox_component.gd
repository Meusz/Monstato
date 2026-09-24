class_name HitboxComponent
extends Area2D

## Component that deals damage when it overlaps with a HurtboxComponent.
## Attach to projectiles, weapons, or any damage-dealing entity.

signal hit_landed(target: Node, damage: float)

@export var damage: float = 10.0
@export var damage_type: int = 0
@export var knockback_force: float = 100.0
@export var source: Node

var _active: bool = true
var _last_knockback_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	monitoring = true
	monitorable = true

func _on_area_entered(hurtbox: Area2D) -> void:
	if not _active:
		return
	if hurtbox is HurtboxComponent:
		_last_knockback_direction = _calculate_knockback_direction(hurtbox)
		hit_landed.emit(hurtbox.get_parent(), damage)

func _calculate_knockback_direction(hurtbox: HurtboxComponent) -> Vector2:
	if source and source is Node2D:
		return (hurtbox.get_parent().global_position - source.global_position).normalized()
	return Vector2.RIGHT

func get_damage() -> float:
	return damage

func get_source() -> Node:
	return source

func get_damage_type() -> int:
	return damage_type

func get_knockback_direction() -> Vector2:
	return _last_knockback_direction

func get_knockback_force() -> float:
	return knockback_force

func set_active(active: bool) -> void:
	_active = active
	monitoring = active

func set_damage(value: float) -> void:
	damage = value

func set_damage_source(node: Node) -> void:
	source = node

func set_damage_type(type: int) -> void:
	damage_type = type

func set_knockback_force(force: float) -> void:
	knockback_force = force
