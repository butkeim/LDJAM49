extends Node2D


var _label_fps = null
var world = preload("res://scenes/world/world.tscn")
var intro_over = false

func _init():
	VisualServer.set_debug_generate_wireframes(true)

	# float epsilon
	var b = var2bytes(1, true)
	b[0] = TYPE_REAL
	var e = bytes2var(b)

	#0.00005 minimum step value for depth fighting

func _ready():
	#OS.current_screen = 1
	#OS.window_fullscreen = true
	#OS.window_borderless = true
	$Intro/AnimationPlayer.connect("animation_finished", self, "intro_over")
	_label_fps = get_node_or_null("GUI/LabelFPS")

	$Intro/Cabin/Camera2D.current = true
	#get_viewport().world.fallback_environment.background_mode = Environment.BG_COLOR

func intro_over(s):
	$World.visible = true
	$Intro.visible = false
	$World/Camera2D.current = true
	$World.start_world()
	intro_over = true
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and !intro_over:
		$Intro/AnimationPlayer.play("fall")
		$AudioStreamPlayer.play()

		
	if Input.is_action_just_pressed("ui_reset") and intro_over:
		remove_child($World)
		var new_world = world.instance()
		add_child(new_world)
		new_world.start_world()
	
	if Input.is_action_just_pressed("full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen

	if Input.is_action_just_released("ui_cancel"):
		get_tree().quit()

	if Input.is_action_just_pressed("ui_home"):
		get_viewport().msaa=(get_viewport().msaa + 1 ) % 5
		#print(get_viewport().msaa)

	
	#if Input.is_action_just_pressed("ui_end") && global.debug:
	#	get_viewport().debug_draw=((get_viewport().debug_draw + 1 ) % 2) * 3

	if _label_fps:
		_label_fps.set_text(String(Engine.get_frames_per_second()))
