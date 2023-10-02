extends Node

class_name AsteroidManager

const _prefab_spawner = preload("res://Scenes/AsteroidSpawner.tscn")
var asteroid_types = {"RED": {"material": preload("res://Materials/red.tres")}, "GRN": {"material": preload("res://Materials/green.tres")}, "BLU": {"material": preload("res://Materials/blue.tres")}}

const _additional_spawners_timer = 20
@onready var spawners: Array = []

@export var spaceship: Spaceship

@export var spawnPos: Vector3

func _ready():
	$SpawnTimer.start()

func _process(delta):
	pass

func get_all_asteroids():
	var results = []

	for spawner in spawners:
		results += spawner._asteroids

	return results

func new_spawner(position = null):
	if not position:
		position = Vector3(GameManager.rng.randf_range(-spawnPos.x, spawnPos.x), spawnPos.y, spawnPos.z)

	var spawner = _prefab_spawner.instantiate()
	add_child(spawner)

	spawner.set_spawn_position(position)
	spawner.set_target(spaceship.position)

	var random_key = asteroid_types.keys()[GameManager.rng.randi() % asteroid_types.size()]
	spawner.type = random_key
	spawner.asteroid_type = asteroid_types[random_key]

	spawners.append(spawner)

	spawner.new_asteroid()


func _on_spawn_timer_timeout():
	new_spawner()
	
	var nb_spawner = len(spawners)
	
	if nb_spawner < 3:
		$SpawnTimer.wait_time = 30
	elif nb_spawner < 9:
		$SpawnTimer.wait_time = 20
	elif nb_spawner < 18:
		$SpawnTimer.wait_time = 10
	else:
		$SpawnTimer.paused = true
