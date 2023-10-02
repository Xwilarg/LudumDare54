extends Node

var _grids: Array[Grid]
var grid_prefab = preload("res://Scenes/Slot.tscn")
const _space = .1

func instanciate_slots(g: Grid):
	var lines = g.raw_shape.replace("\r", "").split("\n")
	var zLen = len(lines)
	for z in range(zLen):
		var xLen = len(lines[z])
		for x in range(xLen):
			if (lines[z][x] == 'X'):
				var elem = grid_prefab.instantiate()
				elem.global_position = Vector3(
					g.global_position.x - (xLen + (xLen - 1) * _space) / 2.0 + x + (_space * x),
					g.global_position.y,
					g.global_position.z - (zLen + (zLen - 1) * _space) / 2.0 + z + (_space * z)
				)
				elem.pos = Vector2i(x, z)
				elem.grid = g
				g.register_slot(Vector2i(x, z))
				g.add_child(elem)

func register_grid(g: Grid):
	_grids.append(g)
	instanciate_slots(g)

func try_place(s: Slot, c: Card) -> bool:
	return s.grid.try_place(s, c)
