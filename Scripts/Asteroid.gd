extends Node3D

var hp: int = 100
var target: Node3D
var move_speed: float = 1.3
var rotation_speed: float = PI/250
var rotation_vec: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = get_node("/root/GameManager").rng
	rotation_vec = Vector3(rng.randf_range(0.1, 1.3), rng.randf_range(0.1, 1.3), rng.randf_range(0.1, 1.3)) * 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position.move_toward(target.position, delta*move_speed)
	rotate_x(rotation_speed)
	
	if global_position.is_equal_approx(target.global_position):
		explode()

func explode():
	print("boom")
	self.queue_free()

func set_target(value: Node3D):
	target = value
