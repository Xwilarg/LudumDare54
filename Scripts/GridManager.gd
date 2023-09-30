extends Node3D

const _prefab = preload("res://Scenes/Slot.tscn")
@export_multiline var _data: String
const _space = .1

func _ready():
	var lines = _data.replace("\r", "").split("\n")
	var zLen = len(lines)
	for z in range(zLen):
		var xLen = len(lines[z])
		for i in range(xLen):
			if (lines[z][i] == 'X'):
				var elem = _prefab.instantiate()
				elem.global_position = Vector3(
					global_position.x + i + (_space * i) - xLen / 2.0,
					global_position.y,
					global_position.z + z + (_space * z) - zLen / 2.0
				)
				add_child(elem)
