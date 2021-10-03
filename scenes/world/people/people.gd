extends RigidBody2D

export var speed = 0.0
var direction: int

var position_left_side: Position2D
var position_right_side: Position2D
var sprites: Node2D

func _ready() -> void:
	contact_monitor = true
	contacts_reported = 5
	position_left_side = $"../Cabin/RigidBody2D/Position2DLeftSide"
	position_right_side = $"../Cabin/RigidBody2D/Position2DRightSide"
	sprites = $"Node2D"
	
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
	
	sprites.scale.x = direction * -1
	if direction == 1:
		distance_to_side = position.distance_to(position_right_side.global_position)
	elif direction == -1:
		distance_to_side = position.distance_to(position_left_side.global_position)
	
	var side_factor = distance_to_side / 100
	
	if side_factor > 6:
		side_factor = 6
	elif side_factor < 1.5:
		side_factor = 1.5
	
	apply_central_impulse(Vector2(direction * speed * side_factor * 10, 0))
