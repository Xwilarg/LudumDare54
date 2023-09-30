extends Node3D

var hp: int = 100
var target: Node3D
var move_speed: float = 1.3
var rotation_speed: float = 30
var rotation_vec: Vector3
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation_vec = Vector3(rng.randf_range(0.1, 1.3), rng.randf_range(0.1, 1.3), rng.randf_range(0.1, 1.3))
	$RigidBody3D.angular_velocity = rotation_vec*1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position.move_toward(target.position, delta*move_speed)
	rotate_x(PI/250)
	
	if global_position.is_equal_approx(target.global_position):
		explode()

func explode():
	print("boom")
	self.queue_free()

func set_target(value: Node3D):
	target = value
