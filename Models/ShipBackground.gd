extends Node3D

@onready var x: int = global_position.x

@onready var prep_timer: float = GameManager.rng.randi_range(5, 20)
var dir: bool

const speed = 750

func _process(delta):
	if prep_timer > 0:
		prep_timer -= delta
		if prep_timer <= 0:
			dir = true#GameManager.rng.randi_range(0, 1) == 0
			global_position = Vector3(x if dir else -x, global_position.y, global_position.z)
			global_rotation = Vector3(0, PI/2 if dir else -PI/2, 0)
	else:
		global_position = Vector3(global_position.x + (speed if dir else -speed) * delta, global_position.y, global_position.z)
		if (!dir and global_position.x < x) or (dir and global_position.x > -x):
			prep_timer = GameManager.rng.randi_range(10, 30)
