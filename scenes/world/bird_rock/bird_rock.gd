extends RigidBody2D

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

func _ready() -> void:
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
		$CollisionShape2D.set_deferred("disabled", false)
		
func body_entered_handler(body: Node):
	if body.is_in_group("cabin") && !has_touched_cabin:
		has_touched_cabin = true
		$CollisionShape2D.set_deferred("disabled", true)
		
	
