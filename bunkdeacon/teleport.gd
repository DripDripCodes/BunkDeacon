extends Node3D

@export var port_scene: String
@export var port_x: float
@export var port_y: float
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_entered(area):
	Main.play_x = port_x
	Main.play_y = port_y
	get_tree().change_scene_to_file(port_scene)
