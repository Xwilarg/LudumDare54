extends Node3D

const _prefab = preload("res://Scenes/Slot.tscn")
const _space = .1

@export var grid_ref: Node

func _ready():
	grid_ref.map(Callable(self, "instanciate_slots"))

func instanciate_slots(x: float, y: float, xLen: int, yLen: int, grid_position: Vector3):
	var elem = _prefab.instantiate()
	elem.global_position = Vector3(
		grid_position.x + global_position.x + x + (_space * x) - xLen / 2.0,
		grid_position.y + global_position.y,
		grid_position.z + global_position.y + y + (_space * y) - yLen / 2.0
	)
	add_child(elem)
