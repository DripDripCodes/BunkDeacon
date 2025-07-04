extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Main.goon_alley_killed == true:
		queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Main.goon_alley_killed == true:
		queue_free()
