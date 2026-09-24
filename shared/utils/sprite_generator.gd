class_name SpriteGenerator
extends RefCounted

## Generates pixel art textures at runtime.

static func from_pixel_data(data: Array, pixel_size: int = 1) -> ImageTexture:
	if data.is_empty() or data[0].is_empty():
		return null
	var height: int = data.size()
	var width: int = data[0].size()
	var img: Image = Image.create(width * pixel_size, height * pixel_size, false, Image.FORMAT_RGBA8)
	img.fill(Color.TRANSPARENT)
	for y in height:
		var row: Array = data[y]
		for x in row.size():
			var color: Color = row[x] if row[x] is Color else Color.html(row[x] as String)
			for py in pixel_size:
				for px in pixel_size:
					img.set_pixel(x * pixel_size + px, y * pixel_size + py, color)
	return ImageTexture.create_from_image(img)

static func player_warrior() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#3498db"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#3498db"),Color.html("#3498db"),Color.WHITE,Color.WHITE,Color.html("#3498db"),Color.html("#3498db"),Color.WHITE,Color.WHITE,Color.html("#3498db"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#3498db"),Color.html("#3498db"),Color.WHITE,Color.html("#2c3e50"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#2c3e50"),Color.WHITE,Color.html("#3498db"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#3498db"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#3498db"),Color.TRANSPARENT],
		[Color.html("#3498db"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#3498db"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.html("#2980b9"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2980b9"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a5276"),Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a5276"),Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a5276"),Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a5276"),Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a5276"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func player_ranger() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2ecc71"),Color.html("#2ecc71"),Color.WHITE,Color.WHITE,Color.html("#2ecc71"),Color.html("#2ecc71"),Color.WHITE,Color.WHITE,Color.html("#2ecc71"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2ecc71"),Color.html("#2ecc71"),Color.WHITE,Color.html("#2c3e50"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2c3e50"),Color.WHITE,Color.html("#2ecc71"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.TRANSPARENT],
		[Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1e8449"),Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1e8449"),Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1e8449"),Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1e8449"),Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func player_tank() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b86e5"),Color.html("#5b86e5"),Color.WHITE,Color.WHITE,Color.html("#5b86e5"),Color.html("#5b86e5"),Color.WHITE,Color.WHITE,Color.html("#5b86e5"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b86e5"),Color.html("#5b86e5"),Color.WHITE,Color.html("#2c3e50"),Color.html("#5b86e5"),Color.html("#5b86e5"),Color.html("#2c3e50"),Color.WHITE,Color.html("#5b86e5"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.TRANSPARENT],
		[Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.html("#365f91"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#365f91"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a3a5c"),Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a3a5c"),Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a3a5c"),Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a3a5c"),Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1a3a5c"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func player_mage() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#9b59b6"),Color.html("#9b59b6"),Color.WHITE,Color.WHITE,Color.html("#9b59b6"),Color.html("#9b59b6"),Color.WHITE,Color.WHITE,Color.html("#9b59b6"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#9b59b6"),Color.html("#9b59b6"),Color.WHITE,Color.html("#2c3e50"),Color.html("#9b59b6"),Color.html("#9b59b6"),Color.html("#2c3e50"),Color.WHITE,Color.html("#9b59b6"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT],
		[Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#7d3c98"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#7d3c98"),Color.html("#f39c12"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func enemy_melee() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#2c3e50"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#2c3e50"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.TRANSPARENT],
		[Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func enemy_ranged() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#f1c40f"),Color.html("#2c3e50"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#2c3e50"),Color.html("#f1c40f"),Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT],
		[Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#5b2c6f"),Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#5b2c6f"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func enemy_tank() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#2c3e50"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#2c3e50"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#34495e"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#2c3e50"),Color.TRANSPARENT],
		[Color.html("#2c3e50"),Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#2c3e50"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.html("#1a252f"),Color.TRANSPARENT,Color.html("#1a252f"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func enemy_fast() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.html("#d35400"),Color.html("#d35400"),Color.html("#d35400"),Color.html("#d35400"),Color.html("#d35400"),Color.html("#d35400"),Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func enemy_mini_boss() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#c0392b"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.html("#c0392b"),Color.TRANSPARENT],
		[Color.html("#922b21"),Color.html("#c0392b"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#c0392b"),Color.html("#922b21")],
		[Color.html("#922b21"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#922b21")],
		[Color.TRANSPARENT,Color.html("#922b21"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#922b21"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#922b21"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#922b21"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7b241c"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7b241c"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7b241c"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7b241c"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.html("#922b21"),Color.TRANSPARENT,Color.html("#922b21"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func enemy_boss() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.html("#1a1a2e"),Color.TRANSPARENT],
		[Color.html("#1a1a2e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#1a1a2e")],
		[Color.html("#1a1a2e"),Color.html("#16213e"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#16213e"),Color.html("#1a1a2e")],
		[Color.html("#0f3460"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#0f3460")],
		[Color.html("#0f3460"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#0f3460")],
		[Color.TRANSPARENT,Color.html("#0f3460"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#0f3460"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#0f3460"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#16213e"),Color.html("#0f3460"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#0a0a1a"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#0a0a1a"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#0a0a1a"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#0a0a1a"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.html("#0f3460"),Color.TRANSPARENT,Color.html("#0f3460"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_slime() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.html("#2ecc71"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#2ecc71"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#2ecc71"),Color.TRANSPARENT],
		[Color.html("#2ecc71"),Color.html("#27ae60"),Color.WHITE,Color.html("#2c3e50"),Color.html("#27ae60"),Color.WHITE,Color.html("#2c3e50"),Color.html("#2ecc71")],
		[Color.html("#2ecc71"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#2ecc71")],
		[Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60")],
		[Color.TRANSPARENT,Color.html("#1e8449"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#1e8449"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#1e8449"),Color.html("#1e8449"),Color.html("#1e8449"),Color.html("#1e8449"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_bat() -> ImageTexture:
	return from_pixel_data([
		[Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#8e44ad")],
		[Color.html("#7d3c98"),Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#7d3c98")],
		[Color.html("#7d3c98"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#7d3c98")],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.WHITE,Color.html("#2c3e50"),Color.html("#8e44ad"),Color.WHITE,Color.html("#2c3e50"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#7d3c98"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#7d3c98"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#7d3c98"),Color.html("#7d3c98"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_skeleton() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#ecf0f1"),Color.html("#bdc3c7"),Color.html("#bdc3c7"),Color.html("#bdc3c7"),Color.html("#bdc3c7"),Color.html("#ecf0f1"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#ecf0f1"),Color.html("#2c3e50"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#2c3e50"),Color.html("#ecf0f1"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.html("#ecf0f1"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#ecf0f1"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#ecf0f1"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#ecf0f1"),Color.TRANSPARENT,Color.html("#bdc3c7"),Color.html("#bdc3c7"),Color.TRANSPARENT,Color.html("#ecf0f1"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#bdc3c7"),Color.TRANSPARENT,Color.html("#bdc3c7"),Color.html("#bdc3c7"),Color.TRANSPARENT,Color.html("#bdc3c7"),Color.TRANSPARENT],
	], 2)

static func companion_fire_spirit() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e67e22"),Color.TRANSPARENT],
		[Color.html("#e67e22"),Color.html("#e74c3c"),Color.WHITE,Color.html("#2c3e50"),Color.html("#e74c3c"),Color.WHITE,Color.html("#2c3e50"),Color.html("#e67e22")],
		[Color.html("#e67e22"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e67e22")],
		[Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e67e22"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#c0392b"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#c0392b"),Color.html("#c0392b"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_ice_crystal() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#3498db"),Color.html("#3498db"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#3498db"),Color.html("#5dade2"),Color.html("#5dade2"),Color.html("#3498db"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#3498db"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#3498db"),Color.TRANSPARENT],
		[Color.html("#3498db"),Color.html("#85c1e9"),Color.WHITE,Color.html("#2c3e50"),Color.html("#85c1e9"),Color.WHITE,Color.html("#2c3e50"),Color.html("#3498db")],
		[Color.html("#3498db"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#aed6f1"),Color.html("#aed6f1"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#3498db")],
		[Color.TRANSPARENT,Color.html("#3498db"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#85c1e9"),Color.html("#3498db"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2980b9"),Color.html("#3498db"),Color.html("#3498db"),Color.html("#2980b9"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2980b9"),Color.html("#2980b9"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_shadow_cat() -> ImageTexture:
	return from_pixel_data([
		[Color.html("#2c3e50"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2c3e50")],
		[Color.html("#2c3e50"),Color.html("#34495e"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#34495e"),Color.html("#2c3e50")],
		[Color.TRANSPARENT,Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#34495e"),Color.html("#f1c40f"),Color.html("#2c3e50"),Color.html("#34495e"),Color.html("#f1c40f"),Color.html("#2c3e50"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.html("#34495e"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#34495e"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#34495e"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#34495e"),Color.html("#34495e"),Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#34495e"),Color.html("#34495e"),Color.TRANSPARENT],
		[Color.html("#2c3e50"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#2c3e50")],
	], 2)

static func companion_lightning_bug() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f1c40f"),Color.html("#f1c40f"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f1c40f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#2c3e50"),Color.html("#f39c12"),Color.html("#2c3e50"),Color.html("#f1c40f"),Color.TRANSPARENT],
		[Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f1c40f")],
		[Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#e67e22"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#e67e22"),Color.html("#f39c12"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#e67e22"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#d35400"),Color.html("#d35400"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_poison_spider() -> ImageTexture:
	return from_pixel_data([
		[Color.html("#27ae60"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#27ae60")],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#8e44ad"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.WHITE,Color.html("#2c3e50"),Color.html("#8e44ad"),Color.WHITE,Color.html("#2c3e50"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.html("#8e44ad"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#8e44ad"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#27ae60"),Color.html("#8e44ad"),Color.TRANSPARENT],
		[Color.html("#27ae60"),Color.TRANSPARENT,Color.html("#8e44ad"),Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#8e44ad"),Color.TRANSPARENT,Color.html("#27ae60")],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_stone_golem() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.TRANSPARENT],
		[Color.html("#7f8c8d"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#7f8c8d")],
		[Color.html("#7f8c8d"),Color.html("#95a5a6"),Color.html("#f1c40f"),Color.html("#2c3e50"),Color.html("#95a5a6"),Color.html("#f1c40f"),Color.html("#2c3e50"),Color.html("#7f8c8d")],
		[Color.html("#7f8c8d"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#7f8c8d")],
		[Color.html("#7f8c8d"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#7f8c8d")],
		[Color.TRANSPARENT,Color.html("#7f8c8d"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#95a5a6"),Color.html("#7f8c8d"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.html("#7f8c8d"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 2)

static func companion_phoenix() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.html("#f39c12"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f39c12")],
		[Color.html("#e74c3c"),Color.html("#e74c3c"),Color.WHITE,Color.html("#2c3e50"),Color.html("#e74c3c"),Color.WHITE,Color.html("#2c3e50"),Color.html("#e74c3c")],
		[Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.html("#e74c3c"),Color.html("#f1c40f"),Color.html("#e74c3c"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#c0392b"),Color.html("#c0392b"),Color.html("#e74c3c"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#f39c12"),Color.TRANSPARENT,Color.html("#e74c3c"),Color.html("#e74c3c"),Color.TRANSPARENT,Color.html("#f39c12"),Color.TRANSPARENT],
		[Color.html("#f39c12"),Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f39c12")],
	], 2)

static func coin() -> ImageTexture:
	return from_pixel_data([
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#f1c40f"),Color.html("#f1c40f"),Color.TRANSPARENT,Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f39c12"),Color.html("#f1c40f"),Color.TRANSPARENT],
		[Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f1c40f")],
		[Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f1c40f"),Color.html("#f1c40f"),Color.html("#f39c12"),Color.html("#f1c40f")],
		[Color.TRANSPARENT,Color.html("#f39c12"),Color.html("#e67e22"),Color.html("#e67e22"),Color.html("#f39c12"),Color.TRANSPARENT],
		[Color.TRANSPARENT,Color.TRANSPARENT,Color.html("#e67e22"),Color.html("#e67e22"),Color.TRANSPARENT,Color.TRANSPARENT],
	], 3)
