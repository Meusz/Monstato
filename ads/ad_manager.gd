extends Node

## AdManager - Singleton for ad platform integration (stub/template).
## Connect real SDK plugin methods here when the Android plugin is installed.

signal rewarded_ad_completed(reward_name: String, reward_amount: int)
signal interstitial_dismissed
signal ad_error(error_message: String)

var ad_platform: String = "none"
var is_initialized: bool = false

var _rewarded_ad_id: String = ""
var _reward_callbacks: Dictionary = {}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	print("[AdManager] Initialized (stub mode)")

func init_platform(platform: String, app_id: String) -> void:
	ad_platform = platform
	print("[AdManager] init_platform called: platform='%s', app_id='%s'" % [platform, app_id])
	print("[AdManager] No ad SDK installed yet - running in stub mode")
	is_initialized = true

func request_rewarded(ad_id: String, ad_type: String = "rewarded") -> bool:
	print("[AdManager] request_rewarded: ad_id='%s', ad_type='%s'" % [ad_id, ad_type])
	if not is_initialized:
		print("[AdManager][WARN] Platform not initialized")
		ad_error.emit("Ad platform not initialized")
		return false
	_rewarded_ad_id = ad_id
	print("[AdManager] Rewarded ad requested (stub) - ready immediately")
	return true

func request_interstitial(ad_id: String) -> bool:
	print("[AdManager] request_interstitial: ad_id='%s'" % ad_id)
	if not is_initialized:
		print("[AdManager][WARN] Platform not initialized")
		ad_error.emit("Ad platform not initialized")
		return false
	print("[AdManager] Interstitial ad requested (stub)")
	return true

func show_rewarded(ad_id: String) -> void:
	print("[AdManager] show_rewarded: ad_id='%s'" % ad_id)
	if not is_initialized:
		print("[AdManager][WARN] Platform not initialized, simulating reward")
		_simulate_rewarded()
		return
	if not is_rewarded_ready():
		print("[AdManager][WARN] Rewarded ad not ready")
		ad_error.emit("Rewarded ad not ready")
		return
	print("[AdManager] Showing rewarded ad (stub) - simulating completion")
	_simulate_rewarded()

func show_interstitial(ad_id: String) -> void:
	print("[AdManager] show_interstitial: ad_id='%s'" % ad_id)
	if not is_initialized:
		print("[AdManager][WARN] Platform not initialized")
		return
	print("[AdManager] Showing interstitial ad (stub)")
	await get_tree().create_timer(0.5).timeout
	interstitial_dismissed.emit()
	print("[AdManager] Interstitial dismissed (stub)")

func is_rewarded_ready() -> bool:
	return true

func _simulate_rewarded() -> void:
	print("[AdManager] _simulate_rewarded called")
	var reward_name: String = get_viable_reward_name()
	var reward_amount: int = get_reward_amount(reward_name)
	await get_tree().create_timer(0.3).timeout
	_on_rewarded_completed(reward_name, reward_amount)

func _on_rewarded_completed(reward_name: String, reward_amount: int) -> void:
	print("[AdManager] Reward delivered: '%s' x%d" % [reward_name, reward_amount])
	rewarded_ad_completed.emit(reward_name, reward_amount)

func get_viable_reward_name() -> String:
	return _rewarded_ad_id if _rewarded_ad_id != "" else "reward"

func get_reward_amount(reward_name: String) -> int:
	var config: Resource = _load_config()
	if config and config.has("rewards") and config.rewards.has(reward_name):
		return int(config.rewards[reward_name])
	if reward_name == "gold":
		return 20
	return 1

func _load_config() -> Resource:
	var config_path: String = "res://ads/ad_config.tres"
	if ResourceLoader.exists(config_path):
		return ResourceLoader.load(config_path)
	return null
