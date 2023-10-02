extends Node

class_name Grid

@export_multiline var raw_shape: String

func _ready():
	GameManager.register_grid(self)
