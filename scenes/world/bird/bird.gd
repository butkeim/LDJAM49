extends RigidBody2D

export (float) var speed

var cabin: RigidBody2D
var direction: Vector2
var has_attaked = false
var has_touched = false
var is_on_return = false
var initial_position: Vector2

func _ready() -> void:
	print("spawn bird")
	initial_position = position
	contact_monitor = true
	contacts_reported = 2
	connect("body_entered", self, "body_entered_handler")
	cabin = $"../Cabin/RigidBody2D/"
	direction = position.direction_to(cabin.position)
	
	set_deferred("linear_velocity", Vector2(direction.x * speed, direction.y * speed))
	#set_applied_force(Vector2(direction.x * speed, direction.y * speed))

func _physics_process(delta: float) -> void:
	if is_near_cabin() && !has_attaked:
		has_attaked = true
		set_applied_force(Vector2(direction.x * speed * 20, direction.y * speed * 20))
	if has_touched && !is_on_return:
		is_on_return = true
		var return_direction = position.direction_to(initial_position)
		set_applied_force(Vector2(return_direction.x * speed, return_direction.y * speed))

func is_near_cabin() -> bool:
	var distance_to_cabin = position.distance_to(cabin.position)
	return distance_to_cabin < 300

func body_entered_handler(body: Node):
	if body.is_in_group("cabin"):
		$CollisionShape2D.set_deferred("disabled", true)
		has_touched = true
		
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
