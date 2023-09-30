extends Node3D

var _buttons: Array[ItemButton]
@export var _deck: JSON

var _cards: Array[Card]

var _selected_item: Card
var rng = RandomNumberGenerator.new()

func _init_cards():
	for card in _deck.data:
		_cards.append(Card.new(card))

func subscribe_button(b: ItemButton) -> void:
	if len(_cards) == 0:
		_init_cards()
	b._curr_card = _cards[rng.randi_range(0, len(_cards) - 1)]
	_buttons.append(b)

func load_item(item: Card) -> void:
	_selected_item = item

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera3d = get_node("/root/Root/Camera3D")
		var space_state = get_tree().get_root().get_world_3d().direct_space_state
		var m_pos = get_viewport().get_mouse_position()

		var from = camera3d.project_ray_origin(m_pos)
		var to = from + camera3d.project_ray_normal(m_pos) * 100000.0
		var query = PhysicsRayQueryParameters3D.create(from, to)

		var result = space_state.intersect_ray(query)

		print(result)
