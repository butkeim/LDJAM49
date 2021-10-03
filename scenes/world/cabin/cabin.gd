extends Node2D

export (float) var death_angle
var cabin_rigid_body: RigidBody2D
var join: PinJoint2D
var hasFallen = false
var next_force_to_apply: Vector2
var next_force_position_to_apply: Vector2
var apply_force = false

func _ready() -> void:
	cabin_rigid_body = $RigidBody2D
	join = $PinJoint2D

func _physics_process(delta: float) -> void:
	if apply_force:
		apply_force = false
		cabin_rigid_body.apply_impulse(next_force_position_to_apply, next_force_to_apply)
	if !hasFallen && (cabin_rigid_body.rotation_degrees > death_angle || cabin_rigid_body.rotation_degrees < -death_angle):
		hasFallen = true
		remove_child(join)

func apply_force_at_handler(force: Vector2, position: Vector2):
	print("received")
	next_force_position_to_apply = position
	next_force_to_apply = force
	apply_force = true
	
