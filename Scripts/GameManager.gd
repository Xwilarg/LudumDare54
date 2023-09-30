extends Node

@export var buttons: Array[ItemButton]
@export var deck: JSON

func _ready():
	var card = Card.new(deck.data[0])

func load_item(item: AItem):
	print("hi")
