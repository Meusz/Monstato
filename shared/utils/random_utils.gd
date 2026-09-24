class_name RandomUtils
extends RefCounted

## Utility class for randomized game systems.
## Provides weighted random selection, shuffled arrays, and more.

## Returns a random integer between min_val and max_val (inclusive).
static func randi_range_custom(min_val: int, max_val: int) -> int:
	return randi_range(min_val, max_val)

## Returns a random float between min_val and max_val.
static func randf_range_custom(min_val: float, max_val: float) -> float:
	return randf_range(min_val, max_val)

## Selects a random element from an array.
static func random_choice(array: Array):
	if array.is_empty():
		return null
	return array[randi() % array.size()]

## Selects N unique random elements from an array.
static func random_choices(array: Array, count: int) -> Array:
	if array.is_empty() or count <= 0:
		return []
	var shuffled := array.duplicate()
	shuffled.shuffle()
	var result_count := mini(count, shuffled.size())
	return shuffled.slice(0, result_count)

## Weighted random selection. weights[i] corresponds to items[i].
static func weighted_random(items: Array, weights: Array):
	if items.is_empty() or items.size() != weights.size():
		return null
	var total_weight := 0.0
	for w in weights:
		total_weight += w
	if total_weight <= 0.0:
		return items[randi() % items.size()]
	var roll := randf() * total_weight
	var cumulative := 0.0
	for i in items.size():
		cumulative += weights[i]
		if roll <= cumulative:
			return items[i]
	return items[items.size() - 1]

## Shuffles an array in place and returns it.
static func shuffle_array(array: Array) -> Array:
	array.shuffle()
	return array

## Returns a shuffled copy of an array.
static func shuffled_copy(array: Array) -> Array:
	var copy := array.duplicate()
	copy.shuffle()
	return copy

## Rolls a percentage chance, returns true if successful.
static func chance(percent: float) -> bool:
	return randf() * 100.0 < percent

## Rolls a decimal chance (0.0 to 1.0), returns true if successful.
static func decimal_chance(probability: float) -> bool:
	return randf() < probability

## Rolls dice: count dice with sides each, returns total.
static func roll_dice(count: int, sides: int) -> int:
	var total := 0
	for i in count:
		total += randi_range(1, sides)
	return total

## Returns a random bool with given probability of being true.
static func random_bool(probability: float = 0.5) -> bool:
	return randf() < probability

## Returns a random sign: -1 or 1.
static func random_sign() -> int:
	return 1 if randi() % 2 == 0 else -1

## Generates a random ID string of given length.
static func random_id(length: int = 8) -> String:
	var chars := "abcdefghijklmnopqrstuvwxyz0123456789"
	var result := ""
	for i in length:
		result += chars[randi() % chars.length()]
	return result

## Returns a random color.
static func random_color() -> Color:
	return Color(randf(), randf(), randf())

## Returns a random color within a hue range.
static func random_color_in_hue(min_hue: float, max_hue: float) -> Color:
	var hue := randf_range(min_hue, max_hue)
	return Color.from_hsv(hue, randf_range(0.5, 1.0), randf_range(0.7, 1.0))

## Selects a random item from an array with rarity weights applied.
## items should be Array[Dictionary] with "item" and "weight" keys.
static func rarity_select(items: Array) -> var:
	if items.is_empty():
		return null
	var total_weight := 0.0
	for entry in items:
		total_weight += entry.get("weight", 1.0)
	var roll := randf() * total_weight
	var cumulative := 0.0
	for entry in items:
		cumulative += entry.get("weight", 1.0)
		if roll <= cumulative:
			return entry.get("item")
	return items[items.size() - 1].get("item")
