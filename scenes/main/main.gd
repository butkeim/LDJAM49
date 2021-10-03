extends Node2D


var _label_fps = null


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

	_label_fps = get_node_or_null("GUI/LabelFPS")

	#get_viewport().world.fallback_environment.background_mode = Environment.BG_COLOR


func _process(delta):

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
