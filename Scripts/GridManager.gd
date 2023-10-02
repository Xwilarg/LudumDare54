extends Node

var _grids: Array[Grid]
var grid_prefab = preload("res://Scenes/Slot.tscn")
const _space = .1

func instanciate_slots(g: Grid, get_help: bool):
	var lines = g.raw_shape.replace("\r", "").split("\n")
	var zLen = len(lines)
	for z in range(zLen):
		var xLen = len(lines[z])
		for x in range(xLen):
			if (lines[z][x] == 'X'):
				var elem = grid_prefab.instantiate()
				elem.global_position = Vector3(
					g.global_position.x + (xLen + (xLen - 1) * _space) / 4.0 - x - (_space * x),
					g.global_position.y,
					g.global_position.z + (zLen + (zLen - 1) * _space) / 4.0 - z - (_space * z)
				)
				elem.pos = Vector2i(x, z)
				elem.grid = g
				if get_help:
					get_help = false
					g.help_slot = elem
				g.register_slot(Vector2i(x, z))
				g.add_child(elem)

func register_grid(g: Grid, get_help: bool):
	_grids.append(g)
	instanciate_slots(g, get_help)
