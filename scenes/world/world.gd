extends Node2D

var count_lose = 0

func _ready() -> void:
	$AreaWin.connect("body_entered", self, "win_body_entered_handler")
	$AreaLose.connect("body_entered", self, "lose_body_entered_handler")
	
	for child in get_children():
		if child.has_method("pause"):
			child.pause()

func start_world():
	for child in get_children():
		if child.has_method("start"):
			child.start()
			
func win_body_entered_handler(body):
	print("okau")
	$LabelWin.text = "You survived, well done !"

func lose_body_entered_handler(body):
	count_lose += 1
	if count_lose == 5:
		$LabelLose.text = "Game over... - R to restart"
