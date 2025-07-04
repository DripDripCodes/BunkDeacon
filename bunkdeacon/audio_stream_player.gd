
extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().current_scene != null and get_tree().current_scene is not Gesture:
		match get_tree().current_scene.namae:
			"Atnalta","Alley":
				if not playing and Main.state != "battle":
					stream = load("res://Music1.mp3")
					play()
			_:
				stop()
			

	if Main.state == "battle" or Main.state == "battle_phases":
		stream_paused = true
		Main.move_lock = true
		
