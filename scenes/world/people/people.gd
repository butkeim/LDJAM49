extends RigidBody2D

export var speed = 0
var direction: int


func _ready() -> void:
	contact_monitor = true
	contacts_reported = 10
	pass # Replace with function body.

func _process(delta: float) -> void:
	var collidingbodies = get_colliding_bodies()
	
	if collidingbodies.size() == 0:
		direction = 0
		return
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	else:
		direction = 0

func _physics_process(delta: float) -> void:
	var distance_side_to_player: int
	var distance_to_side = 0
	
	if direction == 0:
		return
	
	if direction == 1:
		distance_to_side = abs(position.x - 125)
	elif direction == -1:
		distance_to_side = abs(position.x - -125)
	
	var side_factor = distance_to_side / 100
	
	if side_factor > 6:
		side_factor = 6
	elif side_factor < 0.1:
		side_factor = 0.1
	
	#print(side_factor)
	apply_central_impulse(Vector2(direction * speed * side_factor, 0))
