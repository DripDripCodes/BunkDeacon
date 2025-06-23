extends Control

@onready var timer = $Timer
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = time
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(int(timer.time_left))


func _on_timer_timeout():
	queue_free() # Replace with function body.
