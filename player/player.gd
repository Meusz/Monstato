extends CharacterBody2D

## Player - Main player controller.
## Handles movement, combat, and stats through component composition.

@onready var movement: Node = $PlayerMovement
@onready var combat: Node = $PlayerCombat
@onready var stats: Node = $PlayerStats
@onready var animations: Node = $PlayerAnimations
@onready var input_handler: Node = $PlayerInput
@onready var dash_ability: Node = $DashAbility
@onready var trainer_ability: Node = $TrainerAbility
@onready var health_comp: HealthComponent = $HealthComponent
@onready var knockback_comp: KnockbackComponent = $KnockbackComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var weapon_pivot: Node2D = $WeaponPivot

func _ready() -> void:
	add_to_group("player")
	_connect_signals()
	_sync_stats_to_data_bus()
	_setup_sprite()

func _setup_sprite() -> void:
	var sprite: Sprite2D = $Sprite2D
	sprite.modulate = Color.WHITE
	var char_name: String = DataBus.player_stats.get("character_name", "Warrior") as String
	match char_name:
		"Warrior":
			sprite.texture = SpriteGenerator.player_warrior()
		"Ranger":
			sprite.texture = SpriteGenerator.player_ranger()
		"Tank":
			sprite.texture = SpriteGenerator.player_tank()
		"Mage":
			sprite.texture = SpriteGenerator.player_mage()
		_:
			sprite.texture = SpriteGenerator.player_warrior()

func _physics_process(delta: float) -> void:
	if GameManager.current_state in [GameManager.GameState.MAIN_MENU, GameManager.GameState.CHARACTER_SELECT, GameManager.GameState.GAME_OVER, GameManager.GameState.VICTORY]:
		return
	var input_dir: Vector2 = input_handler.get_input_direction()
	var knockback: Vector2 = knockback_comp.get_knockback_velocity()
	if dash_ability.is_dashing():
		velocity = dash_ability.get_dash_velocity()
	elif input_handler.is_dash_pressed() and dash_ability.try_dash(input_dir):
		pass
	elif input_handler.is_ability_pressed():
		trainer_ability.activate()
	else:
		movement.handle_movement(self, input_dir, knockback, stats.get_stat("speed"), delta)
	move_and_slide()
	animations.update_animation(input_dir)

func _connect_signals() -> void:
	health_comp.died.connect(_on_died)
	health_comp.damage_taken.connect(_on_damage_taken)
	health_comp.healed.connect(_on_healed)
	health_comp.dodged.connect(_on_dodged)
	hurtbox.knockback_received.connect(knockback_comp.apply_knockback)
	EventBus.dash_used.connect(_on_dash_used)

func _sync_stats_to_data_bus() -> void:
	var player_stats := DataBus.player_stats
	health_comp.max_health = player_stats.get("max_health", 100.0)
	health_comp.current_health = player_stats.get("health", 100.0)
	health_comp.armor = player_stats.get("armor", 0.0)
	stats.set_stats(player_stats)

var _last_damage_source: Node = null

func _on_damage_taken(amount: float, source: Node) -> void:
	DataBus.player_stats["health"] = clampf(health_comp.current_health, 0.0, health_comp.max_health)
	if source:
		_last_damage_source = source
	EventBus.player_damaged.emit(amount, source)
	animations.play_damage_flash()

func _on_died() -> void:
	if _last_damage_source and is_instance_valid(_last_damage_source) and _last_damage_source.is_in_group("enemies"):
		var enemy_data_res: Resource = _last_damage_source.get("enemy_data")
		if enemy_data_res and enemy_data_res.get("enemy_name"):
			DataBus.death_reason = "Killed by %s" % enemy_data_res.enemy_name
		else:
			DataBus.death_reason = "Killed by an enemy"
	GameManager.change_state(GameManager.GameState.GAME_OVER)
	EventBus.player_died.emit()

func _on_dash_used() -> void:
	animations.play_dash_effect()

func _on_healed(amount: float) -> void:
	DataBus.modify_stat("health", amount)
	EventBus.player_healed.emit(amount)

func _on_dodged() -> void:
	EventBus.player_dodged.emit()

func heal(amount: float) -> void:
	health_comp.heal(amount)

func get_player_stats() -> Node:
	return stats
