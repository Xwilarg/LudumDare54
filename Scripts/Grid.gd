extends Node

@export_multiline var raw_shape: String

var shape: PackedStringArray

var placed_items: Dictionary # Dict[Variable2i, AItem]

var nrows: int
var ncols: int


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


func get_grid_center_global_position(slot_size: Vector3, inter_space: float) -> Vector3:
	return self.global_position # + (slot_size + Vector3(inter_space, 0, inter_space)) * Vector3(ncols/2, 0, nrows/2)


func world_position_to_grid_position(world_position: Vector3, slot_size: Vector3, inter_space: float) -> Vector2i:
	var origin = self.global_position - (Vector3(inter_space, 0, inter_space) * Vector3(ncols - 1, 0, nrows - 1) + Vector3(ncols , 0, nrows ) * slot_size) / 2
	var world_relative_coordinate = world_position - origin
	
	var xdim = world_relative_coordinate[2] / (slot_size[2] + inter_space)
	var ydim = world_relative_coordinate[0] / (slot_size[0] + inter_space)
	
	if xdim >= nrows:
		return Vector2i(-1, -1)
	if ydim >= ncols:
		return Vector2i(-1, -1)
	if xdim < 0:
		return Vector2i(-1, -1)
	if ydim < 0:
		return Vector2i(-1, -1)
	return Vector2i(xdim, ydim)


func on_grid(world_position: Vector3, slot_size: Vector3, inter_space: float) -> bool:
	return world_position_to_grid_position(world_position, slot_size, inter_space)[0] > -1


func grid_position_to_world_position(index_position: Vector2i, slot_size: Vector3, inter_space: float) -> Vector3:
	return self.global_position + (slot_size + Vector3(inter_space, 0, inter_space)) * Vector3(index_position[1], 0, index_position[0])


# TODO
func is_shape_placable(shape: PackedStringArray, shape_position_index: Vector2i, position_index: Vector2i) -> bool:
	# TODO: 
	# shape will be only ["X"] for now
	# shape_position_index is then Vector2i(0, 0)
	# sooooooooooooo => return true if position_index is X ...
	return self.shape[position_index[0]][position_index[1]] == "X"


# TODO
func item_has_element_at_position(item_position: Vector2i, position_index: Vector2i) -> bool:
	# TODO:
	# items shape will be only ["X"] for now
	# soooooo => return pos == position_index
	var placed_item: AItem = placed_items[item_position]
	
	return item_position == position_index


func add_item_at_position(new_item: AItem, shape_position_index: Vector2i, position_index: Vector2i) -> void:
	# for each items that have at least one element of their shape inside the shape, we remove it
	for item_position in placed_items.duplicate():
		if item_has_element_at_position(item_position, position_index):
			placed_items.erase(item_position)
	placed_items[position_index] = new_item


func try_place_item(item: AItem, shape_position_index: Vector2i, world_position: Vector3, slot_size: Vector3, inter_space: float) -> bool:
	var grid_position: Vector2i = world_position_to_grid_position(world_position, slot_size, inter_space)
	# check if item is placable:
	if not is_shape_placable(item.shape, shape_position_index, grid_position):
		return false
	# else:
	add_item_at_position(item, shape_position_index, grid_position)
	return true
