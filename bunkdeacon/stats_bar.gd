extends Node2D

@onready var hp_bar = $HPBar
@onready var hp_label = $HPBar/HPLabel

@onready var sp_bar = $SPBar
@onready var sp_label = $SPBar/SPLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sp_label.text =  (str(int(Main.player_current_stats[5]))+"/"+str(int((Main.player_stats[5]))))
	hp_label.text = (str(int(Main.player_current_stats[1]))+"/"+str(int((Main.player_stats[1]))))
	hp_bar.value = (Main.player_current_stats[1]/Main.player_stats[1] * 100)

	sp_bar.value = int((float(Main.player_current_stats[5])/float(Main.player_stats[5])) * 100.0)
