extends Node

var selection = [0,0]
var state = "ow"
var move_lock = false


var play_x = 0
var play_y = 0

##Name, Health, Attack, Defense, Speed, SP
var player_stats = ["You",20,3,5,5,10]
var player_current_stats =["You",20,5,5,5,10]
var player_level = 1
var player_xp = 24
var player_stats_per_level = [
	["You",25,4,5,5,15], #Level 2
	["You",30,4,6,5,25], #Level 3
	["You",40,5,6,6,30], #Level 4
	["You",55,9,8,6,40], #Level 5
	["You",70,11,8,7,50] #Level 6
]
var xp_per_level = [0,25,50,100,150,200,99999999999]


#spells
var spell_selected = ""
var fire_known = true
var bubble_known = true
var enemy = null
var battle_scene = preload("res://battle_scene.tscn")

#items
var inventory = []
var item_selected = ""

#speech
var kill = false
var kill_on_talk = false
var talkee = null
var before_battle_text= ""
var after_battle_text= ""
var wait = 0

#killed bosses
var goon_alley_killed = false
func _ready():
	inventory = []
	var play_x = 0
	var play_y = 0
	state = "ow"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wait -= 1
	if Input.is_action_just_pressed("ui_text_indent") and state == "ow":
		state = "pause"
		wait = 4
	if player_xp >= xp_per_level[player_level]:
		player_level +=1
		player_stats = []
		player_current_stats= []
		for x in player_stats_per_level[player_level-1]:
			player_stats.append(x)
			player_current_stats.append(x)
	if kill:
		talkee.queue_free()
		kill = false
	match state:
		"pause":
			move_lock = true
			if wait <= 0:
				if Input.is_action_just_pressed("ui_text_indent"):	
					state = "ow"
		"Opening Cutscene":
			move_lock = true
			DialogueManager.show_example_dialogue_balloon(preload("res://Intro.dialogue"),"start")
			state = "oc"
		"ow":
			move_lock = false
		"battle":
			move_lock = true
			var bs = battle_scene.instantiate()
			bs.enemy = enemy
			get_tree().current_scene.add_child(bs)
			state = "battle_phases"
	

		"battle_phases":
			move_lock = true
			
		"pause":
			move_lock = true
		"talking":
			move_lock = true
		
