extends Area2D

## Projectile - Moves in a direction and damages enemies on contact.

var _direction: Vector2 = Vector2.RIGHT
var _speed: float = 400.0
var _damage: float = 10.0
var _pierce: int = 0
var _knockback: float = 100.0
var _hit_targets: Array = []
var _lifetime: float = 3.0
var _source: Node = null
var _companion_source: Node = null
var _is_critical: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _draw() -> void:
	draw_circle(Vector2.ZERO, 4.0, Color(1.0, 0.9, 0.3))
	draw_circle(Vector2.ZERO, 2.0, Color(1.0, 1.0, 0.8))

func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()

func setup(dir: Vector2, dmg: float, spd: float, pierce: int, kb: float, source: Node = null, companion_source: Node = null) -> void:
	_direction = dir.normalized()
	_damage = dmg
	_speed = spd
	_pierce = pierce
	_knockback = kb
	_source = source
	_companion_source = companion_source
	rotation = _direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		_hit(body)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent and area.get_parent().is_in_group("enemies"):
		_hit(area.get_parent())

func _hit(target: Node) -> void:
	if target in _hit_targets:
		return
	_hit_targets.append(target)
	if target.has_node("HealthComponent"):
		var health_comp: HealthComponent = target.get_node("HealthComponent")
		health_comp.take_damage(_damage, _source)
		if _companion_source and _companion_source.has_method("set_companion_data"):
			_companion_source.wave_damage_dealt += _damage
		EventBus.projectile_hit.emit(target, _damage, global_position)
		if _is_critical:
			EventBus.critical_hit.emit(target, _damage)
		if _source and _source.is_in_group("player") and _source.has_node("HealthComponent"):
			_source.get_node("HealthComponent").try_life_steal()
	if target.has_node("KnockbackComponent"):
		var kb: KnockbackComponent = target.get_node("KnockbackComponent")
		kb.apply_knockback_from(global_position, _knockback)
	if _pierce <= 0:
		queue_free()
	else:
		_pierce -= 1
