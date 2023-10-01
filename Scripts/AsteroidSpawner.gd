extends Node

const _prefab_Asteroids = [preload("res://Scenes/AsteroidModel/Asteroid_game1.tscn"), preload("res://Scenes/AsteroidModel/Asteroid_game2.tscn")]

var spawn_position: Vector3
var _asteroids: Array[Asteroid]
@onready var spawn_timer: float = 5
@onready var spawn_random_timer: float = 2

var target: Vector3

func set_spawn_position(value: Vector3):
	spawn_position = value

func increase_spawn_rate():
	var change_rate = 0.8
	
	spawn_timer *= change_rate
	spawn_random_timer *= change_rate

func _ready():
	$SpawnTimer.wait_time = spawn_timer
	$SpawnTimer.start()

func _process(delta):
	pass

func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = spawn_timer + GameManager.rng.randi_range(-spawn_random_timer, spawn_random_timer)
	new_asteroid()
	
func new_asteroid():
	var index_prefab = GameManager.rng.randi_range(0, 1)
	
	var asteroid = _prefab_Asteroids[index_prefab]
	asteroid = asteroid.instantiate()
	add_child(asteroid)
	
	_asteroids.append(asteroid)
	
	var rand_position = func(): return GameManager.rng.randf_range(-3, 3)
	var start_position_noise = Vector3(rand_position.call(), rand_position.call(), rand_position.call())
	var start_position = spawn_position + start_position_noise
	
	asteroid.set_target(target)

func set_target(value: Vector3):
	target = value
