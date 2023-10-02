extends Node

@export_multiline var raw_shape: String

var shape: PackedStringArray

var placed_items: Dictionary # Dict[Variable2i, [AItem, shape, anchor]]

var nrows: int
var ncols: int

var slot_size: Vector3
var inter_space: float

# Called when the node enters the scene tree for the first time.
func _ready():
	set_grid_shape_from_raw_string()

func set_grid_shape_from_raw_string() -> void:
	shape = raw_shape.replace("\r", "").split("\n")
	nrows = len(shape)
	ncols = len(shape[0])

func map(callable: Callable):
	if not shape:
		set_grid_shape_from_raw_string()
	for y in range(nrows):
		for x in range(ncols):
			if (shape[y][x] == 'X'):
				callable.call(x, y, ncols, nrows, self.position)

func map_items(callable: Callable):
	for item_anchor in placed_items.values():
		callable.call(item_anchor[0])

func get_grid_center_global_position() -> Vector3:
	return self.global_position 

func world_position_to_grid_position(world_position: Vector3) -> Vector2i:
	var origin = self.global_position - (Vector3(inter_space, 0, inter_space) * Vector3(ncols - 1, 0, nrows - 1) + Vector3(ncols , 0, nrows) * slot_size) / 2
	var world_relative_coordinate = world_position - origin
	
	var row = world_relative_coordinate[2] / (slot_size[2] + inter_space)
	var col = world_relative_coordinate[0] / (slot_size[0] + inter_space)
	
	var error_return_value = Vector2i(-1, -1)
	
	if row >= nrows:
		return error_return_value
	if col >= ncols:
		return error_return_value
	if row < 0:
		return error_return_value
	if col < 0:
		return error_return_value
	return Vector2i(row, col)

func grid_position_to_world_position(index_position: Vector2i) -> Vector3:
	# compute (0, 0) position
	var pos = self.position
	var gpos = self.global_position
	var origin = self.global_position - (Vector3(inter_space, 0, inter_space) * Vector3(ncols - 1, 0, nrows - 1) + Vector3(ncols , 0, nrows) * slot_size) / 2
	return origin + Vector3(index_position[1], 0, index_position[0]) * (slot_size + Vector3(inter_space, 0, inter_space))

func on_grid(world_position: Vector3) -> bool:
	return world_position_to_grid_position(world_position)[0] > -1


func get_enclosing_rectangle(input_shape, input_anchor, input_position) -> Array[Vector2i]:
	var top_left = input_position - input_anchor
	var bottom_right = top_left + Vector2i(len(input_shape) - 1, len(input_shape[0]) - 1)
	return [top_left, bottom_right]

func is_shape_placable(input_shape: PackedStringArray, shape_anchor_position: Vector2i, position_index: Vector2i) -> bool:
	# first, check if the rectangle is fitting 
	var input_nrows = len(input_shape)
	var input_ncols = len(input_shape[0])
	
	# top left corner in grid position
	var input_rectangle = get_enclosing_rectangle(input_shape, shape_anchor_position, position_index)
	
	if input_rectangle[0][0] < 0 or input_rectangle[0][1] < 0: 
		return false

	# bottom right corner in grid position
	if input_rectangle[1][0] >= self.nrows or input_rectangle[1][1] >= self.ncols:
		return false
	
	# now, check that each elements have fitting "X"
	for row in range(input_nrows):
		for col in range(input_ncols):
			# must all be "X" or "." at the same times
			var coord_row = input_rectangle[0][0] + row
			var coord_col =  input_rectangle[0][1] + col
			if input_shape[row][col] == '.': continue
			print("[CG] Registered input " + input_shape[row][col] + " at ("  + str(coord_row) + ";" + str(coord_col) + ")")
			if input_shape[row][col] != self.shape[coord_row][coord_col]:
				print("[CG] Item placement failed: " + input_shape[row][col] + " != " + self.shape[coord_row][coord_col])
				return false

	for item in placed_items.keys():
		var item_nrows = len(placed_items[item][1])
		var item_ncols = len(placed_items[item][1][0])
		for irow in range(item_nrows):
			for icol in range(item_ncols):
				for row in range(input_nrows):
					for col in range(input_ncols):
						var coord_row = input_rectangle[0][0] + row
						var coord_col =  input_rectangle[0][1] + col
						if coord_row == item.x + irow and coord_col == item.y + icol:
							if placed_items.has(item):
								print("[CG] Attemped to place an element that collides with " + placed_items[item][0].name)
								print("[CG] Collision input/" + placed_items[item][0].name + ": " + str(coord_row) + " == " + str(item.x) + " + " + str(irow) + " and " + str(coord_col) + " == " + str(item.y) + " + " + str(icol))
								CardManager.delete_item(placed_items[item][0])
								placed_items[item][0].queue_free()
								placed_items.erase(item)

	# if we pass all the checks, we are good to go !
	# TODO: check if there is another object here
	return true


func placed_item_has_element_in_rectangle(
	placed_item_shape: PackedStringArray, placed_rectangle: Array[Vector2i], 
	input_item_shape: PackedStringArray, input_rectangle: Array[Vector2i]
) -> bool:
	# rectangles coordinates are relatives to the super enclosing shape that contains the rectangles
	# first, translate rectangle positions for input_item in the placed_item plane
	var translation_vector = placed_rectangle[0]
	placed_rectangle = [placed_rectangle[0] - translation_vector, placed_rectangle[1] - translation_vector]
	input_rectangle = [input_rectangle[0] - translation_vector, input_rectangle[1] - translation_vector]
	
	# check that the input_rectangle as at least one element in the placed_rectangle
	# input_rectangle too far to the right
	if input_rectangle[0][0] > placed_rectangle[1][0]:
		return false
	# input_rectangle too far to the left
	if input_rectangle[1][0] < 0:
		return false
	# input_rectangle under
	if input_rectangle[0][1] > placed_rectangle[1][1]:
		return false
	# input_rectangle on top
	if input_rectangle[1][1] < 0:
		return false
	
	# now we have at least one element in common, time to loop
	
	for x in range(placed_rectangle[1][0]):
		for y in range(placed_rectangle[1][1]):
			# first, check that this coordinate is ok for input_shape
			var input_x = input_rectangle[0][0] + x
			var input_y = input_rectangle[0][1] + y
			if input_x >= 0 and input_x <= input_rectangle[1][0] and input_y >= 0 and input_y <= input_rectangle[1][1]:
				# then if both equals "X" : it's a match
				if placed_item_shape[x][y] == "X" and input_item_shape[input_x][input_y] == "X":
					return true
	
	# here the only left solution was that all overlapping positions where "." for one and/or the other
	return false


# check that you can insert before calling this function
func add_item_at_grid_position(input_item: Node3D, input_item_shape: PackedStringArray, input_item_shape_anchor: Vector2i, position_index: Vector2i) -> void:
	# first, get the top left and bottom right indexes of the inserted shape
	var input_rectangle = get_enclosing_rectangle(input_item_shape, input_item_shape_anchor, position_index)
	
	# for each items that have at least one element of their shape inside the shape, we remove it
	for placed_item_grid_position in placed_items.duplicate():
		var placed_item_shape: PackedStringArray = placed_items[placed_item_grid_position][1]
		var placed_item_anchor: Vector2i = placed_items[placed_item_grid_position][2]
		var placed_rectangle: Array[Vector2i] = get_enclosing_rectangle(placed_item_shape, placed_item_anchor, placed_item_grid_position)
		
		#if placed_item_has_element_in_rectangle(placed_item_shape, placed_rectangle, input_item_shape, input_rectangle):
		#	placed_items.erase(placed_item_grid_position)
		#	CardManager.delete_item(placed_items[placed_item_grid_position][0])
		#	placed_items[placed_item_grid_position][0].queue_free()
			
			
	placed_items[position_index] = [input_item, input_item_shape, input_item_shape_anchor]
	# place item at its position:
	var world_anchor_position = grid_position_to_world_position(position_index)
	var world_zero_coordinates = world_anchor_position - Vector3(len(input_item_shape)/2.0 , 0, len(input_item_shape[0])/2.0)
	input_item.global_position = world_anchor_position
	

func add_item_at_world_position(input_item: Node3D, input_item_shape: PackedStringArray, input_item_shape_anchor: Vector2i, world_position: Vector3) -> void:
	var grid_position: Vector2i = world_position_to_grid_position(world_position)
	add_item_at_grid_position(input_item, input_item_shape, input_item_shape_anchor, grid_position)

