extends Node

class_name Grid

@export_multiline var raw_shape: String

# Elements already placed on the grid
var elems: Dictionary

func _ready():
	GridManager.register_grid(self)

func register_slot(pos: Vector2):
	elems[pos] = null

func try_place(s: Slot, c: Card) -> bool:
	for yc in len(c.shape):
		for xc in len(c.shape[yc]):
			var y = yc + s.pos.y
			var x = xc + s.pos.x
			var v = Vector2(x, y)
			if !elems.has(v) or elems[v] != null:
				return false
				
	for yc in len(c.shape):
		for xc in len(c.shape[yc]):
			var y = yc + s.pos.y
			var x = xc + s.pos.x
			elems[Vector2(x, y)] = s
	return true
