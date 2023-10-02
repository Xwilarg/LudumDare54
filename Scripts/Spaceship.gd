extends Node3D

class_name Spaceship

const max_hp: int = 20
@onready var current_hp: int = max_hp
var current_shield: int = 0

func take_damage(value: int):
	if current_shield >= value:
		current_shield -= value
		return

	value -= current_shield
	current_shield = 0
	
	current_hp -= max(value, 0)
	
	if current_hp == 0:
		get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
