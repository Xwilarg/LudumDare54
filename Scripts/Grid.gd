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
			var y = yc + s.pos.y + c.offset.y
			var x = xc + s.pos.x + c.offset.x
			var v = Vector2(x, y)
			var symbol = c.shape[yc][xc]
			print("[GR] Checking at " + str(v) + " does the grid have it: " + str(elems.has(v)))
			if symbol == 'X' and (!elems.has(v) or elems[v] != null):
				if elems[v] != null:
					CardManager.delete_item(elems[v].obj)
					elems[v].obj.queue_free() # TODO: crash
					elems[v].obj = null
				else:
					return false
				
	for yc in len(c.shape):
		for xc in len(c.shape[yc]):
			var y = yc + s.pos.y + c.offset.y
			var x = xc + s.pos.x + c.offset.x
			elems[Vector2(x, y)] = s
	return true
