extends RigidBody2D

export (float) var speed = 0.0
var direction: int

var position_left_side: Position2D
var position_right_side: Position2D
var sprites: Node2D
onready var animation_player = $AnimationPlayer

var paused = true

var sounds: Array
var play_sound_stop = true

func pause():
	paused = true
	$AnimationPlayer.stop(true)

func start():
	paused = false
	$AnimationPlayer.play()

func _ready() -> void:
	set_sounds_res()
	contact_monitor = true
	contacts_reported = 5
	position_left_side = $"../Cabin/RigidBody2D/Position2DLeftSide"
	position_right_side = $"../Cabin/RigidBody2D/Position2DRightSide"
	sprites = $"Node2D"
	$"../Copter".connect("has_arrived", self, "saved_handler")
	
	$"Node2D/bob".frame = 0
	
func _process(delta: float) -> void:
	if paused:
		return
	var collidingbodies = get_colliding_bodies()
	var cabin_collided = false
	for cb in collidingbodies:
		if cb.is_in_group("cabin"):
			cabin_collided = true

	if !cabin_collided:
		animation_player.play("fall")
	else:
		animation_player.play("move")

	play_scream(cabin_collided)
	
	if !cabin_collided:
		direction = 0
		return
	
	
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	else:
		direction = 0

func _physics_process(delta: float) -> void:
	if paused:
		return
	var distance_side_to_player: int
	var distance_to_side = 0
	
	if direction == 0:
		return

	sprites.scale.x = direction * -abs(sprites.scale.x)
	if direction == 1:
		distance_to_side = position.distance_to(position_right_side.global_position)
	elif direction == -1:
		distance_to_side = position.distance_to(position_left_side.global_position)
	
	var side_factor = distance_to_side / 100
	
	if side_factor > 6:
		side_factor = 6
	elif side_factor < 0.5:
		side_factor = 0.5
	
	apply_central_impulse(Vector2(direction * speed * side_factor * 10, 0))
	
func saved_handler(copter):
	paused = true

func set_sounds_res():
	if self.name == "People":
		sounds.append(add_audio_stream("res://sounds/momImSorry.wav"))
		sounds.append(add_audio_stream("res://sounds/LookOut.wav"))
		sounds.append(add_audio_stream("res://sounds/HelpMe.wav"))
	elif self.name == "Stephanie" || self.name == "Jen":
		sounds.append(add_audio_stream("res://sounds/crisfemme1.wav"))
		sounds.append(add_audio_stream("res://sounds/crisfemme2.wav"))
	elif self.name == "Jimmy":
		sounds.append(add_audio_stream("res://sounds/enfantCri1.wav"))
		sounds.append(add_audio_stream("res://sounds/enfantcri2.wav"))
	else:
		sounds.append(add_audio_stream("res://sounds/criHomme1.wav"))
		sounds.append(add_audio_stream("res://sounds/crihomme2.wav"))
		

func add_audio_stream(path) -> AudioStreamPlayer:
	var stream = load(path)
	var player = AudioStreamPlayer.new()
	player.stream = stream
	add_child(player)
	return player

func play_scream(cabin_collided):
	if !play_sound_stop && !cabin_collided && sounds.size() != 0:
		print("plt")
		var id_to_play = randi() % sounds.size()
		print(id_to_play)
		if !is_any_sound_playing():
			sounds[id_to_play].play()
			play_sound_stop = true
	elif cabin_collided:
		play_sound_stop = false

func is_any_sound_playing() -> bool:
	for sound in sounds:
		if sound.is_playing():
			return true
	return false
		
	
