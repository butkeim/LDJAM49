extends Node2D

var bird = preload("res://scenes/world/bird/bird.tscn")

var cabin: RigidBody2D
var timer: float = 0
var threshold: float

export var threshold_min = 1
export var threshold_max = 4
export var spawn_distance = 700

func _ready() -> void:
	randomize()
	cabin = $"../Cabin/RigidBody2D/"

func _process(delta: float) -> void:
	timer += delta
	
	if timer > threshold:
		timer = 0
		threshold = rand_range(threshold_min, threshold_max)
		
		var spawn_vec = Vector2(cabin.position.x + spawn_distance, cabin.position.y)
		var spawn_vec_rotated = spawn_vec.rotated(deg2rad(get_random_valid_angle()))
		var instance_bird = bird.instance()
		instance_bird.position = spawn_vec_rotated
		instance_bird.speed = 100
		get_parent().add_child(instance_bird)

func get_random_valid_angle() -> float:
	if rand_range(0, 1) > 0.5:
		return rand_range(-50, 50)
	else:
		return rand_range(130, 230)
