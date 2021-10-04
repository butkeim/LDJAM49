extends Node2D

export (float) var death_angle
var cabin_rigid_body: RigidBody2D
var join: PinJoint2D
var hasFallen = false
var next_force_to_apply: Vector2
var next_force_position_to_apply: Vector2
var apply_force = false
var paused = true
var win = false
var win_copter

var audio_player
var collapse_audio_player

func pause():
	paused = true
	cabin_rigid_body.mode = RigidBody2D.MODE_STATIC

func start():
	paused = false
	cabin_rigid_body.mode = RigidBody2D.MODE_RIGID

func _ready() -> void:
	audio_player = $AudioStreamPlayer
	collapse_audio_player = $AudioStreamPlayer2
	cabin_rigid_body = $RigidBody2D
	join = $PinJoint2D
	$"../Copter".connect("has_arrived", self, "start_win_dequence")


func _physics_process(delta: float) -> void:
	if paused:
		return
	crack_volume_from_angle()
	if win:
		$KinematicBody2D.move_and_collide(Vector2(0, -30) * delta)
	if apply_force:
		apply_force = false
		cabin_rigid_body.apply_impulse(next_force_position_to_apply, next_force_to_apply)
	if !hasFallen && (cabin_rigid_body.rotation_degrees > death_angle || cabin_rigid_body.rotation_degrees < -death_angle):
		audio_player.stop()
		collapse_audio_player.play()
		hasFallen = true
		remove_child(join)
		$"RigidBody2D/CollisionShape2D".set_deferred("disabled", true)
		$"RigidBody2D/CollisionShape2D2".set_deferred("disabled", true)

func crack_volume_from_angle():
	var angle = abs(cabin_rigid_body.rotation_degrees) * 1.8# * 1.1
	audio_player.volume_db = clamp(-10 + angle, -10, 25)
	

func apply_force_at_handler(force: Vector2, position_out: Vector2):
	if force.y > 0:
		force = force.rotated(deg2rad(180))
	next_force_position_to_apply = cabin_rigid_body.to_local(position_out)
	next_force_to_apply = force
	apply_force = true
	
func start_win_dequence(copter):
	if !hasFallen:
		win_copter = copter
		win = true
		remove_child(join)
		$KinematicBody2D/CollisionShape2D.set_deferred("disabled", false)
