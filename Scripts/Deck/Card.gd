class_name Card

func _init(json: Dictionary):
	name = tr(json.name.to_upper() + "_NAME")
	description = tr(json.name.to_upper() + "_DESC")

	energyCost = json.name.energyCost
	effects = json.effects
	if json.model == "size2Guns": model = preload("res://Models/size2Guns.glb")

	if json.size == "S1":
		previewModel = preload("res://Models/upgradePlaceholderBlock.glb")
		shape = ["X"]
	elif json.size == "S2":
		previewModel = preload("res://Models/upgradePlaceholderBlock2.glb")
		shape = ["X", "X"]
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
