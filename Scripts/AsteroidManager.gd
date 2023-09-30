extends Node

const _prefab_Asteroid = preload("res://Scenes/Asteroid.tscn")

@export var spaceship: Node3D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var asteroid = _prefab_Asteroid.instantiate()
	asteroid.global_position = spaceship.global_position + Vector3(-10, 0, 10)
	asteroid.set_target(spaceship)

	add_child(asteroid)
	$SpawnTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	# spawns a new asteroid at irregular interval


func _on_spawn_timer_timeout():
	pass # Replace with function body.
	$SpawnTimer.wait_time = rng.randf_range(2, 5)
	new_asteroid()
	
func new_asteroid():
	var asteroid = _prefab_Asteroid.instantiate()
	asteroid.position = spaceship.position + Vector3(-10, 0, 10)
	asteroid.set_target(spaceship)
	add_child(asteroid)
