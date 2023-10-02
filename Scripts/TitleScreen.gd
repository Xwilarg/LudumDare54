extends Node
var locale = OS.get_locale()

const text_default_color = Color.WHITE
const mouse_hover_color = Color.CYAN

# Called when the node enters the scene tree for the first time.
func _ready():
	if locale != "fr_FR":
		locale = "en"
	else:
		locale = "fr"
	
	# get correct translation
	_menu_in_language(locale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_credits_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene_to_file("res://Scenes/Credits.tscn")


func _on_language_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		if locale == "en":
			TranslationServer.set_locale("fr")
			_menu_in_language("fr")
			locale = "fr"
		else:
			TranslationServer.set_locale("en")
			_menu_in_language("en")
			locale = "en"
		

func _menu_in_language(locale: String = "en"):
		$MarginContainer/VBoxContainer/VBoxContainer/Start.text = tr("MENU_START")
		$MarginContainer/VBoxContainer/VBoxContainer/Credits.text = tr("MENU_CREDITS")
		$MarginContainer/VBoxContainer/VBoxContainer/Language.text = tr("MENU_LANGUAGE")


func _on_start_mouse_entered():
	$MarginContainer/VBoxContainer/VBoxContainer/Start.add_theme_color_override("font_color", mouse_hover_color)


func _on_start_mouse_exited():
	$MarginContainer/VBoxContainer/VBoxContainer/Start.add_theme_color_override("font_color", text_default_color)


func _on_credits_mouse_entered():
	$MarginContainer/VBoxContainer/VBoxContainer/Credits.add_theme_color_override("font_color", mouse_hover_color)


func _on_credits_mouse_exited():
	$MarginContainer/VBoxContainer/VBoxContainer/Credits.add_theme_color_override("font_color", text_default_color)


func _on_language_mouse_entered():
	$MarginContainer/VBoxContainer/VBoxContainer/Language.add_theme_color_override("font_color", mouse_hover_color)


func _on_language_mouse_exited():
	$MarginContainer/VBoxContainer/VBoxContainer/Language.add_theme_color_override("font_color", text_default_color)
