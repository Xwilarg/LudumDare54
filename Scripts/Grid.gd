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


func get_grid_center_global_position(item_size: Vector3) -> Vector3:
	return self.global_position + item_size * Vector3(ncols/2, 0, nrows/2)


# TODO
func world_position_to_grid_position(pos: Vector3) -> Vector2i:
	# return back the grid (x, y) index position
	return Vector2i(-1, -1)

# TODO
func is_shape_placable(shape: PackedStringArray, shape_position_index: Vector2i, position_index: Vector2i) -> bool:
	return false

# TODO
func item_has_element_at_position(pos: Vector2i, position_index: Vector2i):
	var placed_item: AItem = placed_items[pos]
	
	return false


func add_item_at_position(new_item: AItem, shape_position_index: Vector2i, position_index: Vector2i) -> void:
	# for each items that have at least one element of their shape inside the shape, we remove it
	for pos in placed_items.duplicate():
		if item_has_element_at_position(pos, position_index):
			placed_items.erase(pos)
	placed_items[position_index] = new_item


func try_place_item(item: AItem, shape_position_index: Vector2i, mouse_position: Vector3) -> bool:
	var grid_position: Vector2i = world_position_to_grid_position(mouse_position)
	# check if item is placable:
	if not is_shape_placable(item.shape, shape_position_index, grid_position):
		return false
	# else:
	add_item_at_position(item, shape_position_index, grid_position)
	return true
