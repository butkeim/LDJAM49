extends RigidBody2D

const carrier = preload("res://scenes/world/bird_rock/bird_rock_carrier.gd")

export (float) var speed = 100
var rigidbody: RigidBody2D

var position_left_side: Position2D
var position_right_side: Position2D

var drop_x: float
var has_stopped = false
var has_been_dropped = false
var has_touched_cabin = false
var has_rebound = false

var timer_before_drop = 0.0
var time_before_drop = 0.2

var paths_sound_impact: Array

func _ready() -> void:
	paths_sound_impact.append("res://sounds/hit3.wav")
	paths_sound_impact.append("res://sounds/hit4.wav")
	
	position_left_side = $"../Cabin/RigidBody2D/Position2DLeftSide"
	position_right_side = $"../Cabin/RigidBody2D/Position2DRightSide"
	drop_x = rand_range(position_left_side.global_position.x, position_right_side.global_position.x)
	gravity_scale = 0
	apply_central_impulse(Vector2(speed, 0))
	connect("body_entered", self, "body_entered_handler")

func _process(delta: float):
	if has_stopped:
		timer_before_drop += delta

func _physics_process(delta: float) -> void:
	if has_touched_cabin && !has_rebound:
		has_rebound = true
		apply_central_impulse(Vector2(20, -6000))

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if global_position.x > drop_x && !has_stopped:
		has_stopped = true
		state.linear_velocity = Vector2(0, 0)
	if timer_before_drop > time_before_drop && !has_been_dropped:
		has_been_dropped = true
		gravity_scale = 1
		var bird = $Node2D as carrier
		var bird_global_position = bird.global_position
		remove_child(bird)
		get_parent().add_child(bird)
		bird.move_out()
		bird.global_position = bird_global_position
		$CollisionShape2D.set_deferred("disabled", false)
		
func body_entered_handler(body: Node):
	if body.is_in_group("cabin") && !has_touched_cabin:
		
		run_sound(paths_sound_impact)
		
		has_touched_cabin = true
		$CollisionShape2D.set_deferred("disabled", true)

		var particle  = $Particles2D
		remove_child(particle)
		get_parent().add_child(particle)
		particle.global_position = global_position + particle.position
		particle.emitting = true

		var particle2  = $Particles2D2
		remove_child(particle2)
		get_parent().add_child(particle2)
		particle2.global_position = global_position + particle2.position
		particle2.emitting = true
		
		yield(get_tree().create_timer(20.0), "timeout")
		particle.queue_free()
		particle2.queue_free()
	
func run_sound(sound_paths):
	var stream = load(sound_paths[randi() % sound_paths.size()])
	var player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()

func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	pass # Replace with function body.
