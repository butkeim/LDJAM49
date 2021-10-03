extends Node2D

var bird = preload("res://scenes/world/bird/bird.tscn")
var bird_rock = preload("res://scenes/world/bird_rock/bird_rock.tscn")

var cabin: RigidBody2D
var timer: float = 0
var threshold: float
var timer_rock: float = 0
var threshold_rock: float = 7

export var threshold_min = 1
export var threshold_max = 4
export var spawn_distance = 700

export var threshold_rock_min = 6
export var threshold_rock_max = 10

func _ready() -> void:
	randomize()
	cabin = $"../Cabin/RigidBody2D/"

func _process(delta: float) -> void:
	threshold_spawn(delta)
	threshold_rock_spawn(delta)

func threshold_spawn(delta: float):
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

func threshold_rock_spawn(delta: float):
	timer_rock += delta
	if timer_rock > threshold_rock:
		timer_rock = 0
		threshold_rock = rand_range(threshold_rock_min, threshold_rock_max)
		var instance_rock = bird_rock.instance()
		instance_rock.position = Vector2(cabin.position.x - 500, cabin.position.y - rand_range(170, 200))
		get_parent().add_child(instance_rock)
		

func get_random_valid_angle() -> float:
	var dispatcher_rand = rand_range(0, 1)
	
	if dispatcher_rand < 0.25:
		return rand_range(-50, -30)
	elif dispatcher_rand >= 0.25 && dispatcher_rand < 0.50:
		return rand_range(30, 50)
	elif dispatcher_rand >= 0.50 && dispatcher_rand < 0.75:
		return rand_range(130, 150)
	else:
		return rand_range(210, 230)
