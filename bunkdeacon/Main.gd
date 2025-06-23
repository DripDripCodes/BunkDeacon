extends Node

var selection = [0,0]
var state = "ow"
var move_lock = false
##Name, Health, Attack, Defense, Speed, SP
var player_stats = ["You",20,5,5,5,10]
var player_current_stats =["You",20,5,5,5,10]
var player_level = 1

var player_stats_per_level = [
	["You",25,7,5,5,15], #Level 2
	["You",30,7,6,5,25], #Level 3
	["You",40,9,6,6,30], #Level 4
	["You",55,11,8,6,40], #Level 5
	["You",70,13,8,7,50] #Level 6
]

#spells
var spell_selected = ""
var fire_known = true
var enemy = null
var battle_scene = preload("res://battle_scene.tscn")


func _ready():
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		"ow":
			move_lock = false
		"battle":
			move_lock = true
			var bs = battle_scene.instantiate()
			bs.enemy = enemy
			get_tree().current_scene.add_child(bs)
			state = "battle_phases"
		"pause":
			move_lock = true

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
