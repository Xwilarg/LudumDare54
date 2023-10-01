extends Node

const _prefab_Asteroids = [preload("res://Scenes/AsteroidModel/Asteroid_game1.tscn"), preload("res://Scenes/AsteroidModel/Asteroid_game2.tscn")]
const _default_spawns = [Vector3(-10, 0, 10), Vector3(10, 0, 10), Vector3(20, 0, 10)]  # todo: change to real spawn points

var _asteroids: Array[Asteroid]

@export var spaceship: Node3D

var _aaTimer: float = 1.0

func _ready():
	new_asteroid()
	
	$SpawnTimer.start()

func _process(delta):
	_aaTimer -= delta
	if _aaTimer <= 0.0:
		_asteroids[GameManager.rng.randi_range(0, len(_asteroids) - 1)].take_damage(10)
		_aaTimer = 1.0


func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = GameManager.rng.randi_range(5, 10)
	new_asteroid()
	
func new_asteroid():
	var index_prefab = GameManager.rng.randi_range(0, 1)
	
	var asteroid = _prefab_Asteroids[index_prefab]
	asteroid = asteroid.instantiate()
	add_child(asteroid)
	
	_asteroids.append(asteroid)
	
	var rand_position = func(): return GameManager.rng.randf_range(-3, 3)
	var start_position = Vector3(rand_position.call(), rand_position.call(), rand_position.call())
	start_position += _default_spawns[GameManager.rng.randi_range(0, 2)]
	
	asteroid.position = spaceship.position + start_position
	asteroid.set_target(spaceship)
