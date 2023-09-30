extends Button

class_name ItemButton

var _curr_card: Card

func _ready():
	get_node("/root/GameManager").subscribe_button(self)

func _on_pressed():
	get_node("/root/GameManager").load_item(_curr_card)

func set_card(c: Card):
	_curr_card = c
	text = c.name
