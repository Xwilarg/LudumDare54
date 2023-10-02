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
var meteo: String

func _init_cards():
	for card in _deck.data:
		_cards.append(Card.new(card))

func subscribe_button(b: CardUI) -> void:
	if len(_cards) == 0:
		_init_cards()
	update_button(b)
	_buttons.append(b)

func load_item(b: CardUI, card: Card) -> void:
	_selected_card = card
	if hintObject != null:
		hintObject.queue_free()
	hintObject = card.previewModel.instantiate()
	add_child(hintObject)
	current_button = b

func on_meteo_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	meteo = tr("TEMPERATURE") + tr("COLON") + " " + str(json["current_weather"]["temperature"]) + json["current_weather_units"]["temperature"] + "\n"
	meteo += tr("WIND_SPEED") + tr("COLON") + " " + str(json["current_weather"]["windspeed"]) + json["current_weather_units"]["windspeed"]
	print("[GM] Meteo loaded: " + meteo)

func _ready():
	time_start = Time.get_unix_time_from_system()
	meteo = "Can't contact meteo API"
	Ghttp.request_completed.connect(on_meteo_completed)
	var resp = Ghttp.request("https://api.open-meteo.com/v1/forecast?latitude=48.85&longitude=2.35&current_weather=true")

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
	var info_level = CardManager.sum(CardManager.get_effect("SEN"))
	var text = ""
	
	if info_level > 0: # Ship HP
		var spaceship = get_node("/root/Root/spaceship")
		text += tr("SHIP_HULL") + tr("COLON") + " " + str(spaceship.current_hp) + "/" + str(spaceship.max_hp) + "\n"
		text += tr("SHIELD") + tr("COLON") + " " + str(spaceship.current_shield) + "\n\n"
	
	if info_level > 1: # Energy
		var asteroids = get_node("/root/Root/AsteroidManager").get_all_asteroids()
		text += tr("ENERGY") + tr("COLON") + " " + str(CardManager._energy_max - CardManager._energy_used) + "/" + str(CardManager._energy_max) + "\n\n"

	if info_level > 2: # Attack power
		text += tr("ATTACK_POWER") + "\n"
		text += tr("GRN_DMG") + tr("COLON") + " " + str(CardManager.sum(CardManager.get_effect("ATK_GRN"))) + "\n"
		text += tr("BLU_DMG") + tr("COLON") + " " + str(CardManager.sum(CardManager.get_effect("ATK_BLU"))) + "\n"
		text += tr("RED_DMG") + tr("COLON") + " " + str(CardManager.sum(CardManager.get_effect("ATK_RED")))
		text += "\n\n"

	if info_level > 3:
		text += tr("METEO") + "\n" + meteo + "\n\n"

	if info_level > 4:
		text += tr("FAVORITE_CHEESE") + "\n" + tr("FETA") + "\n" + tr("GRUYERE") + "\n" + tr("AMERICAN_CHEESE") + "\n\n"
		
	get_node("/root/Root/UI/CaptorInfo").text = text

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1 and _selected_card != null:
		
		if !CardManager.can_be_placed(_selected_card):
			var energy_alert = get_node(("/root/Root/UI/MissingEnergy"))
			energy_alert.text = "[center]" + tr("MISSING_ENERGY") + "[/center]"
			$EnergyAlert.start()
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
							update_button(current_button)
							isDone = true
						break
					else:
						pass# print("Magic is gone booo")
				if isDone:
					break

		# We unselect the card
		hintObject.queue_free()
		hintObject = null
		_selected_card = null

func verify_all_buttons():
	var upgradeLevel = CardManager.sum(CardManager.get_effect("UPG")) + 1
	for b in _buttons:
		print(b._curr_card.name + " : " +  str(b._curr_card.level) + " > " + str(upgradeLevel))
		if b._curr_card.level > upgradeLevel:
			update_button(b)

func update_button(b: CardUI):
	var upgradeLevel = CardManager.sum(CardManager.get_effect("UPG")) + 1
	var nextCard = b._curr_card
	var name: String
	if nextCard != null: name = b._curr_card.name
	while nextCard == null or nextCard.name == name or nextCard.level > upgradeLevel:
		nextCard = _cards[rng.randi_range(0, len(_cards) - 1)]
	print("[GM] Loading card " + nextCard.name + " of level " + str(nextCard.level) + " (Current level: " + str(upgradeLevel) + ")")
	b.set_card(nextCard)


func _on_energy_alert_timeout():
	var energy_alert = get_node(("/root/Root/UI/MissingEnergy"))
	energy_alert.text = ""
	$EnergyAlert.wait_time = 3
	$EnergyAlert.stop()
	
