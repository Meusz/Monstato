class_name MathUtils
extends RefCounted

## Utility class for common math operations used throughout the game.

## Clamps a value between min and max.
static func clampf_custom(value: float, min_val: float, max_val: float) -> float:
	return clampf(value, min_val, max_val)

## Linearly interpolates between two values.
static func lerp_custom(a: float, b: float, weight: float) -> float:
	return lerpf(a, b, weight)

## Returns the sign of a value: -1, 0, or 1.
static func sign_custom(value: float) -> float:
	if value > 0.0:
		return 1.0
	elif value < 0.0:
		return -1.0
	return 0.0

## Wraps a value around within a range [min, max).
static func wrap(value: float, min_val: float, max_val: float) -> float:
	var range_size := max_val - min_val
	return fmod(value - min_val + range_size, range_size) + min_val

## Returns the distance squared between two points (faster than distance).
static func distance_squared(a: Vector2, b: Vector2) -> float:
	return (b - a).length_squared()

## Returns the direction vector from point A to point B.
static func direction_to(a: Vector2, b: Vector2) -> Vector2:
	return (b - a).normalized()

## Checks if a point is within a circle.
static func is_in_circle(point: Vector2, center: Vector2, radius: float) -> bool:
	return distance_squared(point, center) <= radius * radius

## Checks if a point is within a rectangle.
static func is_in_rect(point: Vector2, rect_pos: Vector2, rect_size: Vector2) -> bool:
	return point.x >= rect_pos.x and point.x <= rect_pos.x + rect_size.x \
		and point.y >= rect_pos.y and point.y <= rect_pos.y + rect_size.y

## Converts a Vector2 direction to an angle in degrees.
static func direction_to_angle(direction: Vector2) -> float:
	return rad_to_deg(direction.angle())

## Converts an angle in degrees to a unit Vector2 direction.
static func angle_to_direction(angle_deg: float) -> Vector2:
	return Vector2.from_angle(deg_to_rad(angle_deg))

## Returns a random angle in radians.
static func random_angle() -> float:
	return randf() * TAU

## Returns a random direction as a unit Vector2.
static func random_direction() -> Vector2:
	return Vector2.from_angle(random_angle())

## Returns a random point within a circle of given radius.
static func random_point_in_circle(radius: float) -> Vector2:
	var angle := random_angle()
	var r := sqrt(randf()) * radius
	return Vector2(cos(angle), sin(angle)) * r

## Returns a random point on the edge of a circle.
static func random_point_on_circle(radius: float) -> Vector2:
	return random_direction() * radius

## Returns a random point within a rectangle.
static func random_point_in_rect(size: Vector2) -> Vector2:
	return Vector2(randf_range(-size.x / 2.0, size.x / 2.0), randf_range(-size.y / 2.0, size.y / 2.0))

## Smoothly approaches a target value.
static func smooth_damp(current: float, target: float, velocity: float, smooth_time: float, delta: float) -> float:
	var omega := 2.0 / maxf(smooth_time, 0.0001)
	var x := omega * delta
	var exp_decay := 1.0 / (1.0 + x + 0.48 * x * x + 0.235 * x * x * x)
	var change := current - target
	var temp := (velocity + omega * change) * delta
	velocity = (velocity - omega * temp) * exp_decay
	return target + (change + temp) * exp_decay

## Checks if a float is approximately equal to another.
static func approximately(a: float, b: float, tolerance: float = 0.0001) -> bool:
	return absf(a - b) <= tolerance

## Returns the greater of two values.
static func maxf_custom(a: float, b: float) -> float:
	return maxf(a, b)

## Returns the lesser of two values.
static func minf_custom(a: float, b: float) -> float:
	return minf(a, b)

## Performs a smoothstep interpolation.
static func smoothstep(edge0: float, edge1: float, x: float) -> float:
	var t := clampf((x - edge0) / (edge1 - edge0), 0.0, 1.0)
	return t * t * (3.0 - 2.0 * t)

## Performs a smootherstep interpolation.
static func smootherstep(edge0: float, edge1: float, x: float) -> float:
	var t := clampf((x - edge0) / (edge1 - edge0), 0.0, 1.0)
	return t * t * t * (t * (t * 6.0 - 15.0) + 10.0)
