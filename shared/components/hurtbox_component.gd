class_name HurtboxComponent
extends Area2D

## Component that detects when the owning entity takes damage.
## Attach to any entity that can be damaged.

signal damage_received(amount: float, source: Node, damage_type: int)
signal knockback_received(direction: Vector2, force: float)

@export var health_component: HealthComponent

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	if not health_component:
		health_component = get_parent().get_node_or_null("HealthComponent")

func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is HitboxComponent:
		var damage: float = hitbox.get_damage()
		var source: Node = hitbox.get_source()
		var dtype: int = hitbox.get_damage_type()
		var knockback_dir: Vector2 = hitbox.get_knockback_direction()
		var knockback_force: float = hitbox.get_knockback_force()
		_take_damage(damage, source, dtype, knockback_dir, knockback_force)

func _take_damage(amount: float, source: Node, damage_type: int, knockback_dir: Vector2, knockback_force: float) -> void:
	if health_component:
		health_component.take_damage(amount, source)
	damage_received.emit(amount, source, damage_type)
	if knockback_dir != Vector2.ZERO and knockback_force > 0.0:
		knockback_received.emit(knockback_dir, knockback_force)
