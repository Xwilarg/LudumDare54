extends Node

@onready var asteroidManager: AsteroidManager = get_node("/root/Root/AsteroidManager")

var _aaTimer: float = 1.0
var _items: Array[ItemCard]
var _effects: Dictionary

func get_effect(str: String) -> int:
	if _effects.has(str):
		return _effects[str]
	return 0

func _process(delta):
	_aaTimer -= delta
	if _aaTimer <= 0.0:
		var asteroids = asteroidManager.get_all_asteroids()
		
		if len(asteroids) > 0:
			asteroids[GameManager.rng.randi_range(0, len(asteroids) - 1)].take_damage(get_effect("ATK"))
			_aaTimer = 1.0

func register_item(item: ItemCard):
	_items.append(item)

func delete_item(node: Node3D):
	for item in _items:
		if item.item == node:
			_items.erase(item)
