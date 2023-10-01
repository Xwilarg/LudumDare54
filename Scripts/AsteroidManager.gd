extends Node

class_name AsteroidManager

const _prefab_spawner = preload("res://Scenes/AsteroidSpawner.tscn")
const _default_spawns = [Vector3(-10, 0, 10), Vector3(10, 0, 10), Vector3(-10, 0, 0)]  # todo: change to real spawn points

const _additional_spawners_timer = 10

func _ready():
	for pos in _default_spawns:
		new_spawner(pos)

func _on_spawn_timer_timeout():
	$SpawnTimer.wait_time = GameManager.rng.randi_range(5, 10)

func new_spawner(position = null):
	if not position:
		pass
	
	var pos_index = GameManager.rng.randi_range(0, len(_default_spawns) - 1)

