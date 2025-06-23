extends Control
class_name Battle_Textbox

@onready var dialogue = $TextboxContainer/MarginContainer/HBoxContainer/Label
@onready var timer= $Timer
@onready var speakerboxx = $"Name Container"
@onready var fight_button = $"Fight Button"
@onready var item_button = $"Item Button"
@onready var spray_button = $"Spray Button"
@onready var flee_button = $"Flee Button"

var text = ""
var letter_index = 0

var done = false
var letter_time = .01
var space_time = .02
var punctuation_time = .1

var speaker = ""
signal finished_displaying
func _ready():
	if speaker == "":
		speakerboxx.visible = false
func _process(delta):
	if done:
		await get_tree().create_timer(1).timeout
		self.queue_free()
		finished_displaying.emit()
	if Input.is_action_pressed("x"):
		letter_time = .005
		space_time = .01
		punctuation_time = .05
	else:
		letter_time = .01
		space_time = .02
		punctuation_time = .1

func display_text(text_dis: String):
	text = text_dis

	dialogue.text = ""
	display_letter()
	
func display_letter():
	
	if letter_index >= text.length()-1:
		done = true
		return
	else:
		dialogue.text += text[letter_index]
		letter_index += 1
	match text[letter_index]:
		"!","?",",","?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			 
func _on_timer_timeout():
	display_letter()
