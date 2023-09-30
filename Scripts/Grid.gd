extends Node

@export_multiline var raw_shape: String

var shape: PackedStringArray

# Called when the node enters the scene tree for the first time.
func _ready():
	set_grid_shape_from_raw_string()


func set_grid_shape_from_raw_string() -> void:
	shape = raw_shape.replace("\r", "").split("\n")


func map(callable: Callable):
	if not shape:
		set_grid_shape_from_raw_string()
	var yLen = len(shape)
	for y in range(yLen):
		var xLen = len(shape[y])
		for x in range(xLen):
			if (shape[y][x] == 'X'):
				callable.call(x, y, xLen, yLen, self.position)
