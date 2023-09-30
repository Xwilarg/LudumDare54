extends Button

class_name ItemButton

var _curr_card: Card

func _on_pressed():
	get_node("/root/GameManager").load_item(_curr_card)
