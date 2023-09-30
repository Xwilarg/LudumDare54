class_name Card

func _init(json: Dictionary):
	name = tr(json.name.to_upper() + "_NAME")
	description = tr(json.name.to_upper() + "_DESC")
	
	effects = json.effects
	if json.model == "size2Guns": preload("res://Models/size2Guns.glb")

var name: String
var description: String
var model: PackedScene
var effects: Dictionary

var modelRef = {
	"size2Guns": "res://Models/size2Guns.glb"
}
