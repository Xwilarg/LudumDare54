extends Node

class_name AsteroidManager

const _prefab_spawner = preload("res://Scenes/AsteroidSpawner.tscn")
var _default_spawns = [Vector3(-10, 0, 10), Vector3(10, 0, 10), Vector3(-10, 0, 0)]  # todo: change to real spawn points

const _additional_spawners_timer = 10
@onready var spawners: Array = []

@export var spaceship: Spaceship

@export var _editor_spawns:Array = []

func _ready():
	_get_spawners();

	for pos in _default_spawns:
		new_spawner(pos)

func _process(delta):
	_aaTimer -= delta
	
	if _aaTimer <= 0.0:
		var asteroids = get_all_asteroids()
		
		asteroids[GameManager.rng.randi_range(0, len(asteroids) - 1)].take_damage(10)
		_aaTimer = 1.0

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
	
	spawners.append(spawner)

func _get_spawners():
	for ndpath in _editor_spawns:
		var spawn = get_node(ndpath);
		_default_spawns.push_back(spawn.global_position);
	print(_editor_spawns);
	print(_default_spawns);
