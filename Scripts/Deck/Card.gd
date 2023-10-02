class_name Card

func _init(json: Dictionary):
	name = tr(json.name.to_upper() + "_NAME")
	description = tr(json.name.to_upper() + "_DESC")

	energyCost = json.energyCost
	effects = json.effects
	level = json.level

	if json.icon == "Antenna": icon = preload("res://Sprites/Antenna.png")
	elif json.icon == "Battery": icon = preload("res://Sprites/Battery.png")
	elif json.icon == "Flak": icon = preload("res://Sprites/Flak.png")
	elif json.icon == "Laser_gun": icon = preload("res://Sprites/Laser_gun.png")
	elif json.icon == "missile": icon = preload("res://Sprites/missile.png")
	elif json.icon == "Nav_table": icon = preload("res://Sprites/Nav_table.png")
	elif json.icon == "Overclock": icon = preload("res://Sprites/Overclock.png")
	elif json.icon == "Sensor": icon = preload("res://Sprites/Sensor.png")
	elif json.icon == "Shield Generator": icon = preload("res://Sprites/Shield Generator.png")
	elif json.icon == "Solar_panel": icon = preload("res://Sprites/Solar_panel.png")

	if json.model == "size1Gun": model = preload("res://Models/size1Gun.glb")
	elif json.model == "size2Guns": model = preload("res://Models/size2Guns.glb")
	elif json.model == "laserSize3L": model = preload("res://Models/laserSize3L.glb")
	elif json.model == "batteryPack": model = preload("res://Models/batteryPack.glb")
	elif json.model == "satelliteDish": model = preload("res://Models/satelliteDish.glb")
	elif json.model == "navConsole": model = preload("res://Models/navConsole.glb")
	elif json.model == "solarPanel": model = preload("res://Models/solarPanel.glb")
	elif json.model == "sensor": model = preload("res://Models/sensor.glb")
	elif json.model == "shieldGenerator": model = preload("res://Models/shieldGenerator.glb")
	elif json.model == "bigWires": model = preload("res://Models/bigWires.glb")
	elif json.model == "laserSize1": model = preload("res://Models/laserSize1.glb")
	elif json.model == "gunSize3L": model = preload("res://Models/gunSize3L.glb")
	elif json.model == "missileSize1": model = preload("res://Models/missileSize1.glb")
	elif json.model == "missileSize2": model = preload("res://Models/missileSize2.glb")
	else: print("Unknown model " + json.model)

	if json.size == "S1":
		previewModel = preload("res://Models/upgradePlaceholderBlock.glb")
		shape = ["X"]
		offset = Vector2i.ZERO
	elif json.size == "S2":
		previewModel = preload("res://Models/upgradePlaceholderBlock2.glb")
		shape = ["X", "X"]
		offset = Vector2i(0, -1)
	elif json.size == "S3":
		previewModel = preload("res://Models/upgradePlaceholderBlock3Straight.glb")
		shape = ["X", "X", "X"]
		offset = Vector2i(0, -1)
	elif json.size == "L2": # Doesn't work!!
		previewModel = preload("res://Models/upgradePlaceholderBlock3L.glb")
		shape = ["XX", "X."]
		offset = Vector2i(0, -1)
	else: print("Unknown size " + json.size)

var name: String
var description: String
var model: PackedScene
var previewModel: PackedScene
var effects: Dictionary
var shape: PackedStringArray
var energyCost: int
var level: int
var offset: Vector2i
var icon: CompressedTexture2D

var modelRef = {
	"size2Guns": "res://Models/size2Guns.glb"
}
