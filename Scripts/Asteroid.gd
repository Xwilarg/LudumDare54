extends Node3D

class_name Asteroid

var hp: int = 100
var target: Vector3
var move_speed: float = 100
@onready var rotation_speed: Vector3 = Vector3(GameManager.rng.randf_range(-PI, PI), GameManager.rng.randf_range(-PI, PI), GameManager.rng.randf_range(-PI, PI))
var parent
var type: String

func _ready():
	$RigidBody3D.max_contacts_reported = 2;
	$"RigidBody3D/Label3D".text = "100 / 100"

func _process(delta):
	$RigidBody3D.linear_velocity = (target - global_position).normalized() * move_speed * delta
	$RigidBody3D/Asteroid_model.rotate_x(rotation_speed.x * delta)
	$RigidBody3D/Asteroid_model.rotate_y(rotation_speed.y * delta)
	$RigidBody3D/Asteroid_model.rotate_z(rotation_speed.z * delta)

func set_material(value):
	var node = get_node("RigidBody3D/Asteroid_model/" + str($RigidBody3D/Asteroid_model.meshpath))
	node.set_surface_override_material(0, value)

func explode():
	parent._asteroids.erase(self)
	self.queue_free()

func take_damage(value: int):
	hp -= value
	if hp <= 0:
		$"RigidBody3D/Label3D".text = "0 / 100"
		explode()
	else:
		$"RigidBody3D/Label3D".text = str(hp) + " / 100"

func set_target(value: Vector3):
	target = value

func set_type(value: String):
	type = value

func _on_rigid_body_3d_body_entered(body):
	var spaceship = body.get_parent()
	spaceship.take_damage(1)
	
	explode()
