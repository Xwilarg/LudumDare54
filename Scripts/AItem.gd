extends Node3D

class_name AItem

@export_multiline var raw_shape: String

var shape: PackedStringArray
var tile_map: Array
var tile_size: int

func _ready():
	for line in shape:
		var row = []
		
		for _char in line:
			row.append(_char == "X")
		
		tile_map.append(row)

func rotate_left():
	# todo: rotation

	# update shape after rotation
	shape = _tile_map_into_packedstringarray()

func rotate_right():
	rotate_left()
	rotate_left()
	rotate_left()
	
	# update shape after rotation
	shape = _tile_map_into_packedstringarray()

func _tile_map_into_packedstringarray():
	var arr = []
	
	for line in tile_map:
		var row = ""
		
		for elem in line:
			var _char
			
			if elem == 1:
				_char = "X"
			else:
				_char = "."
			
			row += _char
		
		arr.append(row)
	
	return PackedStringArray(arr)
