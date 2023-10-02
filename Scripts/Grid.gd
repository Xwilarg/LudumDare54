extends Node

class_name Grid

@export_multiline var raw_shape: String

# Elements already placed on the grid
var elems: Dictionary

@export var startingHelp: bool
var help_slot: Node3D = null

func _ready():
	GridManager.register_grid(self, startingHelp)

func register_slot(pos: Vector2):
	elems[pos] = null

func can_place(s: Slot, c: Card) -> bool:
	for yc in len(c.shape):
		for xc in len(c.shape[yc]):
			var y = yc + s.pos.y + c.offset.y
			var x = xc + s.pos.x + c.offset.x
			var v = Vector2(x, y)
			var symbol = c.shape[yc][xc]
			print("[GR] Checking at " + str(v) + " does the grid have it: " + str(elems.has(v)))
			if symbol == 'X' and !elems.has(v):
				return false
			if symbol == 'X' and elems.has(v) and elems[v] != null:
				var obj = elems[v]
				CardManager.delete_item(obj)
				for key in elems.keys():
					if elems[key] == obj:
						elems[key].queue_free()
						elems[key] = null
	return true

func place(s: Slot, c: Card, obj: Node3D):
	for yc in len(c.shape):
		for xc in len(c.shape[yc]):
			var y = yc + s.pos.y + c.offset.y
			var x = xc + s.pos.x + c.offset.x
			if c.shape[yc][xc] == 'X':
				elems[Vector2(x, y)] = obj
