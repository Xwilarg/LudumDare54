extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/BoxContainer/Back.text = tr("GAMEOVER_BACK")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")
