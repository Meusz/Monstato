extends Node

## RelicItem - Rare items with powerful unique effects.
## Similar to passive but with special behaviors.

var item_data: ItemData
var _is_active: bool = false

func setup(data: ItemData) -> void:
	item_data = data

func activate() -> void:
	if _is_active or not item_data:
		return
	_is_active = true
	item_data.apply_modifiers()
	EventBus.passive_effect_applied.emit(item_data)

func deactivate() -> void:
	if not _is_active or not item_data:
		return
	_is_active = false
	item_data.remove_modifiers()

func is_active() -> bool:
	return _is_active
