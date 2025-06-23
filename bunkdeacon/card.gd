extends Control

@onready var button = $TextureButton
@export var sprite = Resource
var spell
# Called when the node enters the scene tree for the first time.
func _ready():
	button.texture_normal = sprite


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_button_down():
	print("bello")
	Main.spell_selected = "Spell:Fire"
