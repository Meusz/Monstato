extends Node2D

## DamageNumber - Floating text that shows damage dealt.

var _damage: float = 0.0
var _is_critical: bool = false
var _lifetime: float = 1.0
var _velocity: Vector2 = Vector2.UP * 50.0

func setup(damage: float, is_critical: bool = false) -> void:
	_damage = damage
	_is_critical = is_critical
	$Label.text = str(int(damage))
	if is_critical:
		$Label.add_theme_font_size_override("font_size", 24)
		$Label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.1))
		_velocity *= 1.5
	else:
		$Label.add_theme_font_size_override("font_size", 16)
		$Label.add_theme_color_override("font_color", Color.WHITE)

func _process(delta: float) -> void:
	position += _velocity * delta
	_velocity.y += 100.0 * delta
	_lifetime -= delta
	modulate.a = clampf(_lifetime, 0.0, 1.0)
	if _lifetime <= 0.0:
		queue_free()
