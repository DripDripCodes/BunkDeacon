extends Control

@onready var button = $TextureButton
@export var sprite = Resource
var cost: int
var spell
# Called when the node enters the scene tree for the first time.
func _ready():
	button.texture_normal = sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_button_down():
	print("bello")
	if Main.player_current_stats[5] >= cost:
		Main.spell_selected = "Spell:" + str(spell)
		get_parent().get_parent().queue_free()
	else:
		$AudioStreamPlayer2D.stream = load("res://Negatory.wav")
		$AudioStreamPlayer2D.play()
