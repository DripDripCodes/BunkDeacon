extends Node2D


var x_var
var y_var

var x_amount
var y_amount

var x = 0
var y = 0

signal selected

func _ready():
	$SFX.stream = load("res://Blip1.wav")
func _process(delta):
	if Input.is_action_just_pressed("ui_left") and x>0:
		position.x -= x_var
		x -= 1
		$SFX.play()
	if Input.is_action_just_pressed("ui_right") and x<x_amount-1:
		position.x += x_var
		x += 1
		$SFX.play()
	if Input.is_action_just_pressed("ui_up") and y>0:
		position.y -= y_var
		y -= 1
		$SFX.play()
	if Input.is_action_just_pressed("ui_down") and y<y_amount-1:
		position.y += y_var
		y += 1
		$SFX.play()
	if Input.is_action_just_pressed("z"):
		for x in get_parent().get_parent().get_children():
			if x is AudioStreamPlayer2D:
				x.play()
		Main.selection = [x,y]
		selected.emit()
		
