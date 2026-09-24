extends Node

## EnemyHealth - Additional health-specific logic for enemies.
## Extends HealthComponent with enemy-specific behavior.

signal xp_dropped(amount: int)

@export var xp_value: int = 10

func drop_xp() -> void:
	xp_dropped.emit(xp_value)
