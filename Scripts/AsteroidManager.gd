extends Node

const _prefab_Asteroids = [preload("res://Scenes/AsteroidModel/Asteroid_game1.tscn"), preload("res://Scenes/AsteroidModel/Asteroid_game2.tscn")]
const _default_start = Vector3(-10, 0, 10)

@export var spaceship: Node3D

func _ready():
	new_asteroid()
	
	$SpawnTimer.start()


func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = GameManager.rng.randi_range(2, 5)
	new_asteroid()
	
func new_asteroid():
	var index_prefab = GameManager.rng.randi_range(0, 1)
	
	var asteroid = _prefab_Asteroids[index_prefab]
	asteroid = asteroid.instantiate()
	add_child(asteroid)
	
	var rand_position = func(): return GameManager.rng.randf_range(-1, 1)
	var start_position = Vector3(rand_position.call(), rand_position.call(), rand_position.call())
	start_position += _default_start
	
	asteroid.position = spaceship.position + start_position
	asteroid.set_target(spaceship)
