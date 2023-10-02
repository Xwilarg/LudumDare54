extends Node3D

class_name Asteroid

var hp: int = 100
var target: Vector3
var move_speed: float = 100
var rotation_speed: float = PI
var parent
var type: String

func _ready():
	$RigidBody3D.max_contacts_reported = 2;

func _process(delta):
	$RigidBody3D.linear_velocity = (target - global_position).normalized() * move_speed * delta
	$RigidBody3D/Asteroid_model.rotate_x(rotation_speed * delta)

func set_material(value):
	var node = get_node("RigidBody3D/Asteroid_model/" + str($RigidBody3D/Asteroid_model.meshpath))
	node.set_surface_override_material(0, value)

func explode():
	parent._asteroids.erase(self)
	self.queue_free()

func take_damage(value: int):
	hp -= value
	if hp <= 0:
		explode()

func set_target(value: Vector3):
	target = value

func set_type(value: String):
	type = value

func _on_rigid_body_3d_body_entered(body):
	var spaceship = body.get_parent()
	spaceship.take_damage(1)
	
	explode()
