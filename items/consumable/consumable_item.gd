extends Node

## ConsumableItem - One-time use items that provide immediate effects.

var item_data: ItemData

func setup(data: ItemData) -> void:
	item_data = data

func use() -> bool:
	if not item_data:
		return false
	_apply_effect()
	EventBus.consumable_used.emit(item_data)
	return true

func _apply_effect() -> void:
	match item_data.item_name:
		"Health Potion":
			DataBus.modify_stat("health", 30.0)
			EventBus.player_healed.emit(30.0)
		"Mega Health Potion":
			DataBus.modify_stat("health", 75.0)
			EventBus.player_healed.emit(75.0)
		"XP Orb":
			DataBus.add_currency(10)
		_:
			pass
