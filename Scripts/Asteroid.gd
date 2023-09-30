extends Node3D

var hp: int = 100
var target: Node3D
var move_speed: float = 100
var rotation_speed: float = PI

func _process(delta):
	$RigidBody3D.linear_velocity = (target.global_position - global_position).normalized() * move_speed * delta
	$RigidBody3D/CollisionShape3D/MeshInstance3D.rotate_x(rotation_speed * delta)

func explode():
	print("boom")
	self.queue_free()

func set_target(value: Node3D):
	target = value


func _on_rigid_body_3d_body_entered(body):
	print("bodyCOLISION")


func _on_rigid_body_3d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("aze")
