extends Node

class_name AsteroidManager

const _prefab_spawner = preload("res://Scenes/AsteroidSpawner.tscn")
var _default_spawns = []
var asteroid_types = {"RED": {"material": preload("res://Materials/red.tres")}, "GRN": {"material": preload("res://Materials/green.tres")}, "BLU": {"material": preload("res://Materials/blue.tres")}}

const _additional_spawners_timer = 10
@onready var spawners: Array = []

@export var spaceship: Spaceship
@export var _editor_spawns: Array = []

func _ready():
	_get_spawners();

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
		var pos_index = GameManager.rng.randi_range(0, len(_default_spawns) - 1)
		position = _default_spawns[pos_index]

	var spawner = _prefab_spawner.instantiate()
	add_child(spawner)

	spawner.set_spawn_position(position)
	spawner.set_target(spaceship.position)

	var random_key = asteroid_types.keys()[GameManager.rng.randi() % asteroid_types.size()]
	spawner.type = random_key
	spawner.asteroid_type = asteroid_types[random_key]

	spawners.append(spawner)

	spawner.new_asteroid()

func _get_spawners():
	for ndpath in _editor_spawns:
		var spawn = get_node(ndpath);
		_default_spawns.push_back(spawn.global_position);

func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = _additional_spawners_timer
	new_spawner()
