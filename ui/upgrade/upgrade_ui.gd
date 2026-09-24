extends CanvasLayer

## UpgradeUI - Displays upgrade options centered on screen.

@onready var cards_container: HBoxContainer = $CenterContainer/VBoxContainer/CardsContainer
@onready var card_scene: PackedScene = preload("res://ui/upgrade/upgrade_card.tscn")

var _options: Array = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.upgrade_offered.connect(_on_upgrade_offered)
	EventBus.upgrade_completed.connect(_on_upgrade_completed)
	visible = false

func _on_upgrade_offered(upgrades: Array) -> void:
	_options = upgrades
	_display_options()
	visible = true
	get_tree().paused = true

func _display_options() -> void:
	for child in cards_container.get_children():
		child.queue_free()
	for i in _options.size():
		var card := card_scene.instantiate()
		cards_container.add_child(card)
		card.setup(_options[i])
		card.selected.connect(_on_card_selected.bind(i))

func _on_card_selected(index: int) -> void:
	var upgrade_system: Node = get_node_or_null("/root/UpgradeSystem")
	if upgrade_system:
		upgrade_system.select_upgrade(index)
	visible = false
	get_tree().paused = false

func _on_upgrade_completed() -> void:
	visible = false
	get_tree().paused = false
