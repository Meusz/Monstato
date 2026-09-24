extends CanvasLayer

## RewardedAdPanel - Revive/bonus ad prompt panel.
## Shown on death or in shop. Calls AdManager and applies reward.

signal player_should_revive
signal gold_reward_applied(amount: int)

@onready var panel_container: PanelContainer = $PanelContainer
@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel
@onready var body_label: Label = $PanelContainer/VBoxContainer/BodyLabel
@onready var watch_button: Button = $PanelContainer/VBoxContainer/WatchButton
@onready var skip_button: Button = $PanelContainer/VBoxContainer/SkipButton

var _ad_type: String = ""
var _is_active: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	watch_button.pressed.connect(_on_watch_pressed)
	skip_button.pressed.connect(_on_skip_pressed)
	AdManager.rewarded_ad_completed.connect(_on_reward_received)
	AdManager.ad_error.connect(_on_ad_error)

func show_revive_prompt() -> void:
	_ad_type = "revive"
	title_label.text = "Revive with Ad?"
	body_label.text = "Watch a short ad to continue your run!"
	watch_button.text = "Watch Ad"
	skip_button.text = "No Thanks"
	_is_active = true
	visible = true
	get_tree().paused = true

func show_gold_ad_prompt() -> void:
	_ad_type = "gold"
	title_label.text = "Free Gold!"
	body_label.text = "Watch an ad to earn free currency."
	watch_button.text = "Watch Ad"
	skip_button.text = "Close"
	_is_active = true
	visible = true

func close_panel() -> void:
	visible = false
	_is_active = false
	if _ad_type == "revive":
		get_tree().paused = false

func _on_watch_pressed() -> void:
	if not AdManager.is_initialized:
		print("[AdPanel] Ad platform not initialized, simulating reward for '%s'" % _ad_type)
		AdManager.show_rewarded(_ad_type)
		return
	watch_button.disabled = true
	skip_button.disabled = true
	var ad_id: String = _get_ad_id()
	AdManager.show_rewarded(ad_id)

func _on_skip_pressed() -> void:
	print("[AdPanel] Player skipped ad for '%s'" % _ad_type)
	close_panel()

func _on_reward_received(reward_name: String, reward_amount: int) -> void:
	print("[AdPanel] Reward received: '%s' x%d" % [reward_name, reward_amount])
	watch_button.disabled = false
	skip_button.disabled = false

	match _ad_type:
		"revive":
			EventBus.player_revived.emit()
			close_panel()
		"gold":
			DataBus.add_currency(reward_amount)
			EventBus.ad_rewarded.emit(reward_name, reward_amount)
			gold_reward_applied.emit(reward_amount)
			close_panel()

func _on_ad_error(error_message: String) -> void:
	print("[AdPanel] Ad error: %s" % error_message)
	watch_button.disabled = false
	skip_button.disabled = false

func _get_ad_id() -> String:
	match _ad_type:
		"revive": return "rewarded_revive"
		"gold": return "rewarded_gold"
	return "rewarded_default"
