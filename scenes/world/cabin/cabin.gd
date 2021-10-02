extends Node2D

export (float) var death_angle
var cabin_rigid_body: RigidBody2D
var join: PinJoint2D
var hasFallen = false

func _ready() -> void:
	cabin_rigid_body = $RigidBody2D
	join = $PinJoint2D
	

func _process(delta: float) -> void:
	if !hasFallen && (cabin_rigid_body.rotation_degrees > death_angle || cabin_rigid_body.rotation_degrees < -death_angle):
		hasFallen = true
		remove_child(join)
