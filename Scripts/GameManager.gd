extends Node

var _buttons: Array[ItemButton]
@export var _deck: JSON

var _cards: Array[Card]

func _init_cards():
	_cards.append(Card.new(_deck.data[0]))

func subscribe_button(b: ItemButton) -> void:
	if len(_cards) == 0:
		_init_cards()
	b._curr_card = _cards[0]
	_buttons.append(b)

func load_item(item: Card) -> void:
	pass
