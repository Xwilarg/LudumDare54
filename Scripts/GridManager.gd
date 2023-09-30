extends Node3D

const _prefab = preload("res://Scenes/Slot.tscn")
const _space = .1

@export var grid_ref: Array[Node]

func _ready():
	for grid in grid_ref:
		grid.map(Callable(self, "instanciate_slots"))

func instanciate_slots(x: float, z: float, xLen: int, zLen: int, grid_position: Vector3):
	var elem = _prefab.instantiate()
	elem.global_position = Vector3(
		grid_position.x + global_position.x + x + (_space * x) - xLen / 2.0,
		grid_position.y + global_position.y,
		grid_position.z + global_position.z + z + (_space * z) - zLen / 2.0
	)
	add_child(elem)
