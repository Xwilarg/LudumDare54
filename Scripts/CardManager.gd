extends Node

@onready var asteroidManager: AsteroidManager = get_node("/root/Root/AsteroidManager")

var _aaTimer: float = 1.0

func _process(delta):
	_aaTimer -= delta
	if _aaTimer <= 0.0:
		asteroidManager._asteroids[GameManager.rng.randi_range(0, len(_asteroids) - 1)].take_damage(10)
		_aaTimer = 1.0
