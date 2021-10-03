extends RigidBody2D

export (float) var speed

signal entered_cabin(force, position)

var cabin_rigidbody: RigidBody2D
var cabin: Node2D
var area: Area2D
var direction: Vector2
var has_attaked = false
var has_touched = false
var is_on_return = false
var initial_position: Vector2

func _ready() -> void:
	print("spawn bird")
	initial_position = Vector2(global_position.x + rand_range(-400, 400), global_position.y + rand_range(-400, 400))
	contact_monitor = true
	contacts_reported = 2
	area = $"Area2D"
	area.connect("body_entered", self, "body_entered_handler")
	cabin_rigidbody = $"../Cabin/RigidBody2D/"
	cabin = $"../Cabin/"
	connect("entered_cabin", cabin, "apply_force_at_handler")
	direction = position.direction_to(cabin.position)
	
	set_deferred("linear_velocity", Vector2(direction.x * speed, direction.y * speed))
	set_applied_force(Vector2(direction.x * speed, direction.y * speed))

func _process(delta: float) -> void:
	if is_near_cabin() && !has_attaked:
		has_attaked = true
		add_central_force(Vector2(direction.x * speed * 20, direction.y * speed * 20))
	if has_touched && !is_on_return:
		is_on_return = true
		var return_direction = position.direction_to(initial_position)
		add_central_force(Vector2(return_direction.x * speed * 100, return_direction.y * speed * 100))

func is_near_cabin() -> bool:
	var distance_to_cabin = position.distance_to(cabin.position)
	return distance_to_cabin < 300

func body_entered_handler(body: Node):
	if body.is_in_group("cabin"):
		emit_signal("entered_cabin", linear_velocity, position)
		$"Area2D".set_deferred("monitoring", false)
		print("body entered");
		has_touched = true
		
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
