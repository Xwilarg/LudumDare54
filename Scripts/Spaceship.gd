extends Node3D

class_name Spaceship

const max_hp: int = 50
@onready var current_hp: int = max_hp

func _ready():
	pass

func _process(delta):
	pass

func take_damage(value: int):
	current_hp -= max(value, 0)
	
	if current_hp == 0:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
