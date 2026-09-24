extends Area2D

## EnemyProjectile - Red ball projectile shot by ranged enemies.

var _direction: Vector2 = Vector2.RIGHT
var _speed: float = 150.0
var _damage: float = 5.0
var _lifetime: float = 4.0
var _sprite: Sprite2D
var _firing_enemy: Node = null

func _ready() -> void:
	collision_layer = 4
	collision_mask = 1
	z_index = 10
	_sprite = Sprite2D.new()
	_sprite.texture = _generate_texture()
	_sprite.scale = Vector2(2.0, 2.0)
	add_child(_sprite)
	body_entered.connect(_on_body_entered)

func setup(dir: Vector2, dmg: float, spd: float = 300.0, source: Node = null) -> void:
	_direction = dir.normalized()
	_damage = dmg
	_speed = spd
	_firing_enemy = source
	rotation = _direction.angle()

func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta
	_lifetime -= delta
	if _lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.has_node("HealthComponent"):
		var health_comp: HealthComponent = body.get_node("HealthComponent")
		health_comp.take_damage(_damage, _firing_enemy if _firing_enemy else get_parent())
		queue_free()

func _generate_texture() -> ImageTexture:
	var size := 16
	var img := Image.create(size, size, false, Image.FORMAT_RGBA8)
	var center := Vector2(7.5, 7.5)
	for x in range(size):
		for y in range(size):
			var dist := Vector2(x, y).distance_to(center)
			if dist <= 7.0:
				var shade: float = 1.0 - (dist / 7.0) * 0.5
				img.set_pixel(x, y, Color(0.95 * shade, 0.12, 0.12, 1.0))
			elif dist <= 7.5:
				img.set_pixel(x, y, Color(0.95, 0.12, 0.12, 0.6))
			else:
				img.set_pixel(x, y, Color.TRANSPARENT)
	for dx in range(3):
		for dy in range(3):
			var px := 4 + dx
			var py := 4 + dy
			if img.get_pixel(px, py).a > 0.0:
				img.set_pixel(px, py, Color(1.0, 0.55, 0.45, 0.95))
	return ImageTexture.create_from_image(img)
