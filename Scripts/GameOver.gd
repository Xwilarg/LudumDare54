extends Node

const text_default_color = Color.WHITE
const mouse_hover_color = Color.CYAN

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/BoxContainer/Back.text = tr("GAMEOVER_BACK")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")


func _on_back_mouse_entered():
	$Control/BoxContainer/Back.add_theme_color_override("font_color", mouse_hover_color)

func _on_back_mouse_exited():
	$Control/BoxContainer/Back.add_theme_color_override("font_color", text_default_color)
