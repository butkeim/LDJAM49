extends Node2D

var bird = preload("res://scenes/world/bird/bird.tscn")
var bird_rock = preload("res://scenes/world/bird_rock/bird_rock.tscn")

var cabin: RigidBody2D
var timer: float = 0
var threshold: float = 1
var timer_rock: float = 0
var threshold_rock: float = 12

export var threshold_min = 5
export var threshold_max = 9
export var spawn_distance = 700

export var threshold_rock_min = 10
export var threshold_rock_max = 16

var paused = false

func pause():
	paused = true

func start():
	paused = false

func _ready() -> void:
	randomize()
	cabin = $"../Cabin/RigidBody2D/"
	$"../Copter/".connect("has_arrived", self, "stop_handler")

func _process(delta: float) -> void:
	if paused:
		return
	
	threshold_spawn(delta)
	threshold_rock_spawn(delta)

func threshold_spawn(delta: float):
	threshold_min -= delta / 10
	threshold_max -= delta / 10
	threshold_min = clamp(threshold_min, 2, 100)
	threshold_max = clamp(threshold_max, 5, 100)
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
	threshold_rock_min -= delta / 10
	threshold_rock_max -= delta / 10
	threshold_rock_min = clamp(threshold_rock_min, 4, 100)
	threshold_rock_max = clamp(threshold_rock_max, 8, 100)
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
		
func stop_handler(copter):
	paused = true
