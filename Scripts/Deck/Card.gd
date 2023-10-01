class_name Card

func _init(json: Dictionary):
	name = tr(json.name.to_upper() + "_NAME")
	description = tr(json.name.to_upper() + "_DESC")

	energyCost = json.energyCost
	effects = json.effects
	if json.model == "size2Guns": model = preload("res://Models/size2Guns.glb")
	elif json.model == "batteryPack": model = preload("res://Models/batteryPack.glb")
	elif json.model == "satelliteDish": model = preload("res://Models/satelliteDish.glb")
	elif json.model == "navConsole": model = preload("res://Models/navConsole.glb")
	elif json.model == "solarPanel": model = preload("res://Models/solarPanel.glb")
	else: print("Unknown model " + json.model)

	if json.size == "S1":
		previewModel = preload("res://Models/upgradePlaceholderBlock.glb")
		shape = ["X"]
	elif json.size == "S2":
		previewModel = preload("res://Models/upgradePlaceholderBlock2.glb")
		shape = ["X", "X"]
	elif json.size == "S3":
		previewModel = preload("res://Models/upgradePlaceholderBlock3Straight.glb")
		shape = ["X", "X", "X"]
	else: print("Unknown size " + json.size)

var name: String
var description: String
var model: PackedScene
var previewModel: PackedScene
var effects: Dictionary
var shape: PackedStringArray
var energyCost: int

var modelRef = {
	"size2Guns": "res://Models/size2Guns.glb"
}
