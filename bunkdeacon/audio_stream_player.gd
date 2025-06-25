
extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_tree().current_scene != null:	
		if get_tree().current_scene.namae == "Atnalta":
			stop()
		else:
			if not playing:
				play()

	if Main.state == "battle" or Main.state == "battle_phases":
		stream_paused = true
		Main.move_lock = true
		
