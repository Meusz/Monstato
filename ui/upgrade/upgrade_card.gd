extends PanelContainer

## UpgradeCard - A single upgrade option card.

signal selected

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var desc_label: Label = $VBoxContainer/DescLabel
@onready var button: Button = $VBoxContainer/Button

var _upgrade_data: Resource

func setup(data: Resource) -> void:
	_upgrade_data = data
	if data is UpgradeData:
		name_label.text = data.upgrade_name
		desc_label.text = data.description
		button.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	selected.emit()
