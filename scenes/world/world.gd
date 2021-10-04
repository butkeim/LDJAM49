extends Node2D

func _ready() -> void:
	for child in get_children():
		if child.has_method("pause"):
			child.pause()

func start_world():
	for child in get_children():
		if child.has_method("start"):
			child.start()
