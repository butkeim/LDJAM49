extends RigidBody2D

export var speed = 0
var direction: int


func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	else:
		direction = 0

func _physics_process(delta: float) -> void:
	#var side_factor = 0 - position.x
	
	
	apply_central_impulse(Vector2(direction * speed, 0))
