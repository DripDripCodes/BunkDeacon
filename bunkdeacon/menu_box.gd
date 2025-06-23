extends Control

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

signal finished_displaying
func _ready():
	pass
func _process(delta):
	pass
