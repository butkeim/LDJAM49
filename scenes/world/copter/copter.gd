extends Node2D

export (float) var speed = 30
export (float) var threshold = 2
export (float) var threshold_wait = 1
export (float) var destination_y = -130
var descent = false
var ascent = false

func _ready() -> void:
	position = Vector2(0, -200)

func pause():
	pass

func start():
	get_tree().create_timer(threshold).connect("timeout" , self, "start_descent_handler")

func _process(delta: float) -> void:
	if descent && position.y < destination_y:
		position = Vector2(0, position.y + (delta * speed))
	elif position.y >= destination_y:
		get_tree().create_timer(threshold_wait).connect("timeout", self, "start_ascent_handler")
	
	if ascent:
		position = Vector2(0, position.y - (delta * speed))
	
		
func start_descent_handler():
	descent = true

func start_ascent_handler():
	ascent = true
	descent = false

