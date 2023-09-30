extends Node3D

var target: Node3D
var move_speed: int = 1.3
var direction: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = position.move_toward(target.position, delta*move_speed)
	
	if global_position.is_equal_approx(target.global_position):
		explode()

func explode():
	print("boom")
	self.queue_free()

func set_target(value: Node3D):
	target = value
