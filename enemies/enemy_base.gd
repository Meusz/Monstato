extends CharacterBody2D

## EnemyBase - Base class for all enemies.
## Handles ranged attacks based on enemy_data.type.

@onready var ia: Node = $EnemyIA
@onready var movement: Node = $EnemyMovement
@onready var attack: Node = $EnemyAttack
@onready var health_comp: HealthComponent = $HealthComponent
@onready var knockback_comp: KnockbackComponent = $KnockbackComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var hitbox: HitboxComponent = $HitboxComponent
@onready var detection_area: Area2D = $DetectionArea
@onready var sprite: Sprite2D = $Sprite2D

var enemy_data: Resource
var _target: Node2D = null
var _projectile_scene: PackedScene = preload("res://enemies/projectile/enemy_projectile.tscn")

func _ready() -> void:
	add_to_group("enemies")
	_connect_signals()

func _connect_signals() -> void:
	health_comp.died.connect(_on_died)
	health_comp.damage_taken.connect(_on_damage_taken)
	hurtbox.knockback_received.connect(knockback_comp.apply_knockback)
	detection_area.body_entered.connect(_on_detection_body_entered)
	detection_area.body_exited.connect(_on_detection_body_exited)

func _apply_data() -> void:
	if enemy_data:
		var wave: int = DataBus.current_wave
		var health_scale: float = 1.0 + 0.5 * (wave - 1)
		var dmg_scale: float = 1.0 + 0.3 * (wave - 1)
		health_comp.max_health = enemy_data.health * health_scale
		health_comp.current_health = enemy_data.health * health_scale
		health_comp.armor = enemy_data.armor
		attack.damage = enemy_data.damage * dmg_scale
		movement.speed = enemy_data.speed
		attack.damage = enemy_data.damage
		attack.attack_range = enemy_data.attack_range
		attack.cooldown = enemy_data.attack_cooldown
		scale = Vector2.ONE * enemy_data.scale

func set_data(data: Resource) -> void:
	enemy_data = data
	_apply_data()
	_setup_sprite()

func _setup_sprite() -> void:
	if not enemy_data:
		return
	var enemy_type: String = enemy_data.type as String if enemy_data.get("type") else "melee"
	match enemy_type:
		"melee":
			sprite.texture = SpriteGenerator.enemy_melee()
		"ranged":
			sprite.texture = SpriteGenerator.enemy_ranged()
		"tank":
			sprite.texture = SpriteGenerator.enemy_tank()
		"fast":
			sprite.texture = SpriteGenerator.enemy_fast()
		"mini_boss":
			sprite.texture = SpriteGenerator.enemy_mini_boss()
		"boss":
			sprite.texture = SpriteGenerator.enemy_boss()
		_:
			sprite.texture = SpriteGenerator.enemy_melee()
	if enemy_data.get("element") != null:
		sprite.modulate = enemy_data.get_element_color()
		_add_element_indicator(enemy_data.element)

func _add_element_indicator(element: CompanionData.CompanionType) -> void:
	var indicator := Sprite2D.new()
	indicator.position = Vector2(0, 14)
	indicator.texture = SpriteGenerator.coin()
	indicator.scale = Vector2(0.3, 0.3)
	match element:
		CompanionData.CompanionType.GRASS:
			indicator.modulate = Color(0.18, 0.8, 0.44)
		CompanionData.CompanionType.FIRE:
			indicator.modulate = Color(0.91, 0.3, 0.24)
		CompanionData.CompanionType.WATER:
			indicator.modulate = Color(0.2, 0.6, 0.86)
	add_child(indicator)

func get_target() -> Node2D:
	return _target

func is_ranged() -> bool:
	return enemy_data and enemy_data.get("type") == "ranged"

func _perform_ranged_attack() -> void:
	var target := get_target()
	if not target or not _projectile_scene:
		return
	var projectile: Area2D = _projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.global_position = global_position
	var dir: Vector2 = (target.global_position - global_position).normalized()
	projectile.setup(dir, attack.damage, 300.0, self)

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		_target = body

func _on_detection_body_exited(body: Node2D) -> void:
	if body == _target:
		_target = null

func _on_died() -> void:
	EventBus.enemy_killed.emit(self, enemy_data.xp_value if enemy_data else 10)
	queue_free()

func _on_damage_taken(_amount: float, _source: Node) -> void:
	_flash_damage()

func _flash_damage() -> void:
	if not sprite:
		return
	var original_color: Color = sprite.modulate
	sprite.modulate = Color(2.0, 0.4, 0.4, 1.0)
	var tween := create_tween()
	tween.tween_property(sprite, "modulate", original_color, 0.15)

func get_xp_value() -> int:
	if enemy_data:
		return enemy_data.xp_value
	return 10

func _physics_process(_delta: float) -> void:
	move_and_slide()
	position = position.clamp(Vector2.ZERO, Vector2(1200, 900))
