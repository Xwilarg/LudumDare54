extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# get correct translation
	$MarginContainer/VBoxContainer/VBoxContainer/Start.text = tr("MENU_START")
	$MarginContainer/VBoxContainer/VBoxContainer/Credits.text = tr("MENU_CREDITS")
	$MarginContainer/VBoxContainer/VBoxContainer/Language.text = tr("MENU_LANGUAGE")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_credits_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		print("Clicked")


func _on_language_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		print("Clicked")
