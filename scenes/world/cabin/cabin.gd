extends Node2D

export (float) var death_angle
var cabin_rigid_body: RigidBody2D
var join: PinJoint2D
var hasFallen = false
var next_force_to_apply: Vector2
var next_force_position_to_apply: Vector2
var apply_force = false
var paused = true

func pause():
	paused = true
	cabin_rigid_body.mode = RigidBody2D.MODE_STATIC

func start():
	paused = false
	cabin_rigid_body.mode = RigidBody2D.MODE_RIGID

func _ready() -> void:
	cabin_rigid_body = $RigidBody2D
	join = $PinJoint2D

func _physics_process(delta: float) -> void:
	if paused:
		return
	if apply_force:
		apply_force = false
		cabin_rigid_body.apply_impulse(next_force_position_to_apply, next_force_to_apply)
	if !hasFallen && (cabin_rigid_body.rotation_degrees > death_angle || cabin_rigid_body.rotation_degrees < -death_angle):
		print("oooo")
		hasFallen = true
		remove_child(join)
		$"RigidBody2D/CollisionShape2D".set_deferred("disabled", true)
		$"RigidBody2D/CollisionShape2D2".set_deferred("disabled", true)

func apply_force_at_handler(force: Vector2, position_out: Vector2):
	if force.y > 0:
		force = force.rotated(deg2rad(180))
	next_force_position_to_apply = cabin_rigid_body.to_local(position_out)
	next_force_to_apply = force
	apply_force = true
	
