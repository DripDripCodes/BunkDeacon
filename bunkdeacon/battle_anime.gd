extends Control

@onready var sprite = $AnimatedSprite2D
@onready var audio = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent() is Battle:
		sprite.animation = "battle-close"
	else:
		sprite.animation = "battle-open"
		audio.stream = load("res://Battle_Start_Jingle.wav")
		audio.play()
	sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		


func _on_animated_sprite_2d_animation_finished():
	if Main.state != "battle" and Main.state != "battle_phases":
		Main.state = "battle"
	queue_free()
