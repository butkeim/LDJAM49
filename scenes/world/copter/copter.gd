extends RigidBody2D

export (float) var speed = 30
export (float) var threshold = 2
export (float) var threshold_wait = 1
export (float) var destination_y = -130
var descent = false
var ascent = false
var arrived_destination = false
var new_position

signal has_arrived(copter)

func _ready() -> void:
	position = Vector2(0, -300)
	new_position = position

func pause():
	pass

func start():
	get_tree().create_timer(threshold).connect("timeout" , self, "start_descent_handler")

func _process(delta: float) -> void:
	print(new_position)
	if descent && position.y < destination_y:
		new_position = Vector2(0, new_position.y + (delta * speed))
	if position.y >= destination_y && !arrived_destination:
		arrived_destination = true		
		get_tree().create_timer(threshold_wait).connect("timeout", self, "start_ascent_handler")
	if ascent:
		new_position = Vector2(0, new_position.y - (delta * speed))
	
func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	print(new_position)
	position = new_position
	new_position = position
	
func start_descent_handler():
	descent = true

func start_ascent_handler():
	emit_signal("has_arrived", self)
	ascent = true
	descent = false
	


