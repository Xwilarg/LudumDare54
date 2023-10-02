extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var credits = [
		[tr("MENU_CREDITS")],
		[tr("CREDIT_2D"), "Jacob Richer"],
		[tr("CREDIT_3D"), "Jadith Bruzenak", "Madhav"],
		[tr("CREDIT_AUDIO"), "WordedPuppet"],
		[tr("CREDIT_PROGRAMMING"), "Christian Chaux", "Clément Carré", "François Carré", "Lux"],
		[tr("CREDIT_FONT")],
		[tr("CREDIT_METEO")],
		[tr("CREDIT_ANIMALS")]
	]
	
	var text_credits = ""
	print(make_paragraph(credits[0]))
	
	for elements in range(0, credits.size()):
		text_credits += make_paragraph(credits[elements]) + "\n"
	
	print(text_credits)
	
	$Control/Label.text = text_credits
	
	$Control/BoxContainer/Back.text = tr("GAMEOVER_BACK")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn")

func make_paragraph(elements: Array):
	var paragraph = ""
	
	for i in range(0, elements.size()):
		paragraph += elements[i] + "\n"
	
	return paragraph
