extends Node

## ShopSystem - Handles the shop between waves. Sells companions and items.

var _companions_for_sale: Array = []
var _items_for_sale: Array = []
var _refresh_cost: int = 5

func _ready() -> void:
	EventBus.shop_opened.connect(_on_shop_opened)

func _on_shop_opened() -> void:
	_generate_stock()

func _generate_stock() -> void:
	_companions_for_sale.clear()
	_items_for_sale.clear()
	var companions := CompanionDatabase.get_random_companions(4)
	for c in companions:
		_companions_for_sale.append(c)
	var items := ItemDatabase.get_random_items(8)
	for item in items:
		_items_for_sale.append(item)

func get_companions_for_sale() -> Array:
	return _companions_for_sale

func get_items_for_sale() -> Array:
	return _items_for_sale

func buy_companion(index: int) -> bool:
	if index < 0 or index >= _companions_for_sale.size():
		return false
	var companion: CompanionData = _companions_for_sale[index]
	if not DataBus.spend_currency(companion.cost):
		return false
	_companions_for_sale.remove_at(index)
	EventBus.item_purchased.emit(companion, companion.cost)
	return true

func buy_item(index: int) -> bool:
	if index < 0 or index >= _items_for_sale.size():
		return false
	var item: ItemData = _items_for_sale[index]
	if not DataBus.spend_currency(item.cost):
		return false
	_items_for_sale.remove_at(index)
	EventBus.item_purchased.emit(item, item.cost)
	return true

func refresh_shop() -> bool:
	if not DataBus.spend_currency(_refresh_cost):
		return false
	_generate_stock()
	EventBus.shop_refreshed.emit()
	return true

func get_refresh_cost() -> int:
	return _refresh_cost
