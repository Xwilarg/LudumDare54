extends Node

@onready var asteroidManager  = get_node("/root/Root/AsteroidManager")

var _aaTimer: float = 1.0
var _items: Array[ItemCard]

var _energy_max: int = 100
var _energy_used: int = 0

func can_be_placed(card: Card) -> bool:
	if _energy_used + card.energyCost > _energy_max:
		return false
	return true

func get_effect(str: String) -> Array[int]:
	var data: Array[int]
	
	for item in _items:
		if item.card.effects.has(str):
			data.append(int(item.card.effects[str]))
	
	return data

func _process(delta):
	_aaTimer -= delta
	
	if _aaTimer <= 0.0:
		for eff in get_effect("ATK_RED"):
			var asteroids = asteroidManager.get_all_asteroids()
			
			if len(asteroids) > 0:
				print("[CM] Firing at asteroid for " + str(eff) + " damage")
				asteroids[GameManager.rng.randi_range(0, len(asteroids) - 1)].take_damage(eff)
			else:
				break
		
		_aaTimer = 1.0

func register_item(item: ItemCard):
	_energy_used += item.card.energyCost
	_items.append(item)
	if item.card.effects.has("ENG"):
		_energy_used -= int(item.card.effects["ENG"])
		update_ui()
	print("[CM] " + item.card.name + " placed, energy left: " + str(_energy_max - _energy_used))

func delete_item(node: Node3D):
	for item in _items:
		if item.item == node:
			if item.card.effects.has("ENG"):
				_energy_used += int(item.card.effects["ENG"])
				update_ui()
			_items.erase(item)

func update_ui():
	pass
