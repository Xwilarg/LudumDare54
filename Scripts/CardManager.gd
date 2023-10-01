extends Node

@onready var asteroidManager: AsteroidManager = get_node("/root/Root/AsteroidManager")

var _aaTimer: float = 1.0
var _items: Array[ItemCard]

func get_effect(str: String) -> Array[int]:
	var data: Array[int]
	for item in _items:
		if item.card.effects.has(str):
			data.append(item.card.effects[str])
	return data

func _process(delta):
	_aaTimer -= delta
	if _aaTimer <= 0.0:
		var asteroids = asteroidManager.get_all_asteroids()
		for eff in get_effect("ATK"):
			asteroids[GameManager.rng.randi_range(0, len(asteroids) - 1)].take_damage(eff)
		_aaTimer = 1.0

func register_item(item: ItemCard):
	_items.append(item)

func delete_item(node: Node3D):
	for item in _items:
		if item.item == node:
			_items.erase(item)
