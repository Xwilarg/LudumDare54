extends Node3D

class_name GridManager

const _prefab = preload("res://Scenes/Slot.tscn")
const _space = .1

@export var grid_ref: Array[Node]

func _ready():
	for grid in grid_ref:
		grid.map(Callable(self, "instanciate_slots"))
		grid.slot_size = Vector3.ONE
		grid.inter_space  = _space
	get_node("/root/GameManager")._gridManager.append(self)

func instanciate_slots(x: float, z: float, xLen: int, zLen: int, grid_local_position: Vector3):
	var elem = _prefab.instantiate()
	elem.global_position = Vector3(
		grid_local_position.x - (xLen + (xLen - 1) * _space) / 2.0 + x + (_space * x),
		grid_local_position.y,
		grid_local_position.z - (zLen + (zLen - 1) * _space) / 2.0 + z + (_space * z) 
	) 
	add_child(elem)
