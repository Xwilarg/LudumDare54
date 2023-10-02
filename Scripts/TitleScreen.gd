extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	# get correct translation
	$VBoxContainer/VBoxContainer/Start.text = tr("MENU_START")
	$VBoxContainer/VBoxContainer/Credits.text = tr("MENU_CREDITS")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
