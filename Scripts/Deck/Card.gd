class_name Card

func _init(json: Dictionary):
	name = tr(json.name + "_NAME")
	description = tr(json.name + "_DESC")
	
	effects = json.effects
	if json.model == "size2Guns": preload("res://Models/size2Guns.glb")

var name: String
var description: String
var model: PackedScene
var effects: Dictionary

var modelRef = {
	"size2Guns": "res://Models/size2Guns.glb"
}
