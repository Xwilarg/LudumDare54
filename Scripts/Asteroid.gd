extends Node3D

class_name Asteroid

var hp: int = 100
var target: Vector3
var move_speed: float = 100
var rotation_speed: float = PI
var parent

func _ready():
	$RigidBody3D.max_contacts_reported = 2;

func _process(delta):
	$RigidBody3D.linear_velocity = (target - global_position).normalized() * move_speed * delta
	$RigidBody3D/CollisionShape3D/Asteroid_model.rotate_x(rotation_speed * delta)

func explode():
	print("boom")
	parent._asteroids.erase(self)
	self.queue_free()

func take_damage(value: int):
	hp -= value
	if hp <= 0:
		explode()

func set_target(value: Vector3):
	target = value


func _on_rigid_body_3d_body_entered(body):
	print("bodyCOLISION")


func _on_rigid_body_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("aze")
