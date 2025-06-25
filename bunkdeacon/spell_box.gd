extends Control

@onready var grid = $Panel/GridContainer
var text = ""
var letter_index = 0

var done = false
var letter_time = .01
var space_time = .02
var punctuation_time = .1

var sticker = load("res://card.tscn")
signal finished_displaying
func _ready():
	if Main.fire_known == true:
		var sticker_new = sticker.instantiate()

		var sprite = load("res://FireSticker.png")
		sticker_new.sprite = sprite
		sticker_new.spell = "Fire"
		grid.add_child(sticker_new)
func _process(delta):
	pass


func _on_button_button_down():
	queue_free()
