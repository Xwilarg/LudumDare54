extends Node3D

var _buttons: Array[CardUI]
var _gridManager: Array[GridManager]
@export var _deck: JSON

var _cards: Array[Card]

var _selected_card: Card
var rng = RandomNumberGenerator.new()

var hintObject: Node3D
var current_button: CardUI

var time_start: int = 0
var time_now: int = 0
var elapsed_time: int

func _init_cards():
	for card in _deck.data:
		_cards.append(Card.new(card))

func subscribe_button(b: CardUI) -> void:
	if len(_cards) == 0:
		_init_cards()
	b.set_card(_cards[rng.randi_range(0, len(_cards) - 1)])
	_buttons.append(b)

func load_item(b: CardUI, card: Card) -> void:
	_selected_card = card
	if hintObject != null:
		hintObject.queue_free()
	hintObject = card.previewModel.instantiate()
	add_child(hintObject)
	current_button = b

func _ready():
	time_start = Time.get_unix_time_from_system()

func _process(delta):
	time_now = Time.get_unix_time_from_system()
	elapsed_time = time_now - time_start
	
	if hintObject != null:
		var camera3d = get_node("/root/Root/Camera3D")
		var space_state = get_tree().get_root().get_world_3d().direct_space_state
		var m_pos = get_viewport().get_mouse_position()

		var from = camera3d.project_ray_origin(m_pos)
		var to = from + camera3d.project_ray_normal(m_pos) * 100000.0
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collision_mask |= (1 << 1)
		query.collision_mask |= (1 << 2)

		var result = space_state.intersect_ray(query)
		if len(result) > 0:
			hintObject.global_position = result.position
	
	# update UI
	var spaceship = get_node("/root/Root/spaceship")
	var hp_text = "[center]Ship Hull:\n" + str(spaceship.current_hp) + "/" + str(spaceship.max_hp) + "[/center]"
	get_node("/root/Root/UI/ShipHP").text = hp_text
	
	var asteroids = get_node("/root/Root/AsteroidManager").get_all_asteroids()
	var asteroids_text = "Asteroids: " + str(len(asteroids))
	get_node("/root/Root/UI/NbAsteroids").text = asteroids_text

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and _selected_card != null:
		
		if !CardManager.can_be_placed(_selected_card):
			print("[GM] Not enough energy to place " + _selected_card.name)
			return
		
		# We do a raycast to see where we click
		var camera3d = get_node("/root/Root/Camera3D")
		var space_state = get_tree().get_root().get_world_3d().direct_space_state
		var m_pos = event.position

		var from = camera3d.project_ray_origin(m_pos)
		var to = from + camera3d.project_ray_normal(m_pos) * 100000.0
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collision_mask = 2

		var result = space_state.intersect_ray(query)
		
		if len(result) > 0: # If we clicked on a slot...
			# print(result)
			var isDone = false
			for gm in _gridManager:
				for grid in gm.grid_ref:
					if grid.on_grid(result.collider.global_position):
						# ... we place it on the grid
						
						var grid_position = grid.world_position_to_grid_position(result.collider.global_position)
						var world_position = grid.grid_position_to_world_position(grid_position)
						
						# print(result.collider.global_position)
						# print(grid_position)
						# print(world_position)

						var insertable = grid.is_shape_placable(_selected_card.shape, Vector2i(0, 0), grid_position)
						# print(insertable)
						if insertable:
							var item = _selected_card.model.instantiate()
							CardManager.register_item(ItemCard.new(_selected_card, item))
							add_child(item)
							grid.add_item_at_grid_position(item, _selected_card.shape, Vector2i(0, 0), grid_position)
							item.global_position = Vector3(item.global_position.x, item.global_position.y + .5, item.global_position.z)
							# print("It's magic time")
							isDone = true
							var nextCard = current_button._curr_card
							while nextCard.name == current_button._curr_card.name:
								nextCard = _cards[rng.randi_range(0, len(_cards) - 1)]
							current_button.set_card(nextCard)
						break
					else:
						pass# print("Magic is gone booo")
				if isDone:
					break

		# We unselect the card
		hintObject.queue_free()
		hintObject = null
		_selected_card = null

