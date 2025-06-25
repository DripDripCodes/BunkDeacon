extends Node3D
class_name Atnalta

@export var namae: String
@onready var pickup = $Pickup
@onready var player = preload("res://Player.tscn")

var play_x = Main.play_x
var play_y = Main.play_y
# Called when the node enters the scene tree for the first time.
func _ready():

	var play= player.instantiate()
	play.position.x = play_x 
	play.position.z = play_y
	
	add_child(play)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
