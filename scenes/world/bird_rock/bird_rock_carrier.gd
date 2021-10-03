extends Node2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var move_out = false
var speed = 20

func move_out() -> void:
	move_out = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if move_out:
		position += Vector2(speed * delta, -speed * delta)


func _on_VisibilityNotifier2D_screen_exited() -> void:
	if move_out:
		queue_free()
