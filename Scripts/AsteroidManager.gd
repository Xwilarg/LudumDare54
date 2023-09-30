extends Node

const _prefab_Asteroid = preload("res://Scenes/Asteroid.tscn")
const _default_start = Vector3(-10, 0, 10)

@export var spaceship: Node3D

func _ready():
	var asteroid = _prefab_Asteroid.instantiate()
	asteroid.global_position = spaceship.global_position + _default_start
	asteroid.set_target(spaceship)

	add_child(asteroid)
	$SpawnTimer.start()


func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = get_node("/root/GameManager").rng.randi_range(2, 5)
	new_asteroid()
	
func new_asteroid():
	var rng = get_node("/root/GameManager").rng
	var asteroid = _prefab_Asteroid.instantiate()
	var start_position = Vector3(rng.randf_range(-1, 1), rng.randf_range(-1, 1), rng.randf_range(-1, 1))
	start_position += _default_start
	
	asteroid.position = spaceship.position + start_position
	asteroid.set_target(spaceship)
	add_child(asteroid)
