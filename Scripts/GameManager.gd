extends Node

#var buttons: Array[ItemButton]
@export var deck: JSON

func _ready():
	var card = Card.new(deck.data[0])
	#buttons[0]._curr_card = card

func load_item(item: Card):
	print(item.name)
