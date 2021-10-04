extends RigidBody2D

export (float) var speed

signal entered_cabin(force, position)

var cabin_rigidbody: RigidBody2D
var direction: Vector2
var has_attaked = false
var has_touched = false
var is_on_return = false
var initial_position: Vector2
var paths_sound_chant: Array
var paths_sound_impact: Array

func _ready() -> void:
	
	paths_sound_chant.append("res://sounds/bird1.wav")
	paths_sound_chant.append("res://sounds/bird2.wav")
	paths_sound_chant.append("res://sounds/bird3.wav")
	paths_sound_impact.append("res://sounds/hit1.wav")
	paths_sound_impact.append("res://sounds/hit2.wav")
	get_tree().create_timer(rand_range(1, 3)).connect("timeout", self, "run_sound_handler")
	
	initial_position = Vector2(global_position.x + rand_range(-100, 100), global_position.y + rand_range(-100, 100))
	contact_monitor = true
	contacts_reported = 2
	connect("body_entered", self, "body_entered_handler")
	cabin_rigidbody = $"../Cabin/RigidBody2D/"
	direction = set_direction()
	set_deferred("linear_velocity", Vector2(direction.x * speed, direction.y * speed))

func set_direction() -> Vector2:
	return position.direction_to(Vector2(cabin_rigidbody.position.x + rand_range(-110, 110), cabin_rigidbody.position.y))
	

func _process(delta: float) -> void:
	if linear_velocity.x < 0:
		$Node2D.scale.x = -1
	else:
		$Node2D.scale.x = 1		

func _physics_process(delta: float) -> void:
	if is_near_cabin() && !has_attaked:
		has_attaked = true
		add_central_force(Vector2(direction.x * speed * 100, direction.y * speed * 100))
	if has_touched && !is_on_return:
		run_sound(paths_sound_impact)
		is_on_return = true
		var return_direction = position.direction_to(initial_position)
		add_central_force(Vector2(-direction.x * speed * 150, -direction.y * speed * 150))
		apply_central_impulse(Vector2(return_direction.x * speed * 30, return_direction.y * speed * 30))

func is_near_cabin() -> bool:
	var distance_to_cabin = position.distance_to(cabin_rigidbody.position)
	return distance_to_cabin < 300

func body_entered_handler(body: Node):
	if body.is_in_group("cabin"):
		has_touched = true
		$CollisionShape2D.set_deferred("disabled", true)
		var particle  = $Particles2D
		remove_child(particle)
		get_parent().add_child(particle)
		particle.global_position = global_position
		particle.emitting = true
		get_tree().create_timer(20.0).connect("timeout", particle, "queue_free")

func run_sound_handler():
	run_sound(paths_sound_chant)

func run_sound(sound_paths):
	var stream = load(sound_paths[randi() % sound_paths.size()])
	var player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	player.play()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
