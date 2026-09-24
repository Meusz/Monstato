class_name DamageType
extends Resource

## Resource that defines a type of damage with its properties.

enum Type {
	PHYSICAL,
	FIRE,
	ICE,
	LIGHTNING,
	POISON,
	TRUE,
}

@export var damage_type: Type = Type.PHYSICAL
@export var color: Color = Color.WHITE
@export var icon: Texture2D
@export var name: String = "Physical"

## Returns the color associated with this damage type.
func get_color() -> Color:
	match damage_type:
		Type.PHYSICAL: return Color.WHITE
		Type.FIRE: return Color.ORANGE_RED
		Type.ICE: return Color.CYAN
		Type.LIGHTNING: return Color.YELLOW
		Type.POISON: return Color.GREEN
		Type.TRUE: return Color.MAGENTA
	return color

## Returns a DamageType resource for a given type enum.
static func create(type: Type) -> DamageType:
	var dt := DamageType.new()
	dt.damage_type = type
	match type:
		Type.PHYSICAL:
			dt.name = "Physical"
			dt.color = Color.WHITE
		Type.FIRE:
			dt.name = "Fire"
			dt.color = Color.ORANGE_RED
		Type.ICE:
			dt.name = "Ice"
			dt.color = Color.CYAN
		Type.LIGHTNING:
			dt.name = "Lightning"
			dt.color = Color.YELLOW
		Type.POISON:
			dt.name = "Poison"
			dt.color = Color.GREEN
		Type.TRUE:
			dt.name = "True"
			dt.color = Color.MAGENTA
	return dt
