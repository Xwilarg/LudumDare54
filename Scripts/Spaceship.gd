extends Node3D

class_name Spaceship

const max_hp: int = 50
@onready var current_hp: int = max_hp

func _ready():
	GameManager._register_spaceship(self)
