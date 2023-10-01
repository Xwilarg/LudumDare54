extends Node

class_name AsteroidManager

const _prefab_spawner = preload("res://Scenes/AsteroidSpawner.tscn")
var _default_spawns = [Vector3(-10, 0, 10), Vector3(10, 0, 10), Vector3(-10, 0, 0)]  # todo: change to real spawn points

const _additional_spawners_timer = 10

@export var _editor_spawns:Array = []

func _ready():
	_get_spawners();
	for pos in _default_spawns:
		new_spawner(pos)

func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = GameManager.rng.randi_range(5, 10)

func new_spawner(position = null):
	if not position:
		pass
	
	var pos_index = GameManager.rng.randi_range(0, len(_default_spawns) - 1)

func _get_spawners():
	for ndpath in _editor_spawns:
		var spawn = get_node(ndpath);
		_default_spawns.push_back(spawn.global_position);
	print(_editor_spawns);
	print(_default_spawns);
