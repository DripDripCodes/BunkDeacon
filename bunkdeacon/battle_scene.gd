
extends CanvasLayer

#images
@onready var background = $Background
@onready var enem_sprite = $"Enemy Sprite"

var spells = preload("res://spell_box.tscn")
var textbox = load("res://textbox_battle.tscn")
var spellbox = preload("res://textbox_spells.tscn")
var bkg_image = load("res://backgroun_1.tscn")
var main_menu = load("res://menu_box.tscn")


var timer = preload("res://timer.tscn")
var draw = load("res://gesture.tscn")
var draw2 = draw.instantiate()
var phase = "init"


#enemy stuff
var enemy = null
var enemy_moves = []
var enemy_stats = []
var enemy_sprite = null
var en_name = ""

var player_choice = ""
var monster_move = ""
var spelling = false
var spell_count = 0

var draw_surface = draw.instantiate()
var callout_ended = true
signal callout_done
signal callout_box_closed
# Called when the node enters the scene tree for the first time.
func _ready():

	var bg_image = bkg_image.instantiate()
	background.add_child(bg_image)

	draw2.on_draw_exit.connect(done_drawing)
	var mm = main_menu.instantiate()
	add_child(mm)
	mm.fight_button.button_down.connect(main_fight_down)
	mm.item_button.button_down.connect(main_item_down)
	mm.spray_button.button_down.connect(main_spray_down)
	mm.flee_button.button_down.connect(main_flee_down)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if phase == "victory":
		print("Victory")
		var box = textbox.instantiate()
		box.finished_displaying.connect(_on_tb_finish)
		add_child(box)
		box.display_text("You win! ")
		phase = "end"
	if phase == "init":
		enem_sprite.texture = enemy.enem_sprite
		for x in Monster.basic_monsters[enemy.enem_stats]:
			enemy_stats.append(x)
		enemy_moves = Monster.monster_moves[enemy.enem_spells]
		en_name = enemy_stats[0]
		print(Monster.basic_monsters[enemy.enem_stats][1])
		var box = textbox.instantiate()
		box.finished_displaying.connect(_on_tb_finish)
		add_child(box)
		box.display_text(en_name + " approaches! ")
		phase = "player"
	if phase == "player":
		if Main.spell_selected != "":
			player_choice = Main.spell_selected
			phase = "monster"
	if phase == "monster":
		monster_move = enemy_moves[randi_range(0,enemy_moves.size()-1)]
		phase = "callout"
	if phase == "callout":
		var speeds = []
		speeds.append("You:"+str(Main.player_current_stats[4]))
		speeds.append(str(enemy_stats[4]))
		speeds.sort()
		speeds.reverse()
		print(speeds)
		phase = "calling"
		loop_actions(speeds)
		await callout_done
		if enemy_stats[1] <= 0:
			phase = "victory"
		else:
			phase = "player"
			Main.spell_selected = ""

func main_fight_down():
	if phase == "player":
		player_choice = "Attack:Player"
		phase = "monster"
		print("Fight")
func main_item_down():
	if phase == "player":
		print("Item")
func main_spray_down():
	if phase == "player":
		var spellbook = spells.instantiate()
		add_child(spellbook)
		print("Spray")
func main_flee_down():
	if phase == "player":
		Main.state = "ow"
		queue_free()
		enemy.queue_free()
		print("Flee")
	
func _on_tb_finish():
	if phase == "calling":
		if spelling == false:
			for x in get_children():
				if x is Battle_Textbox:
					x.queue_free()
					callout_ended = true
					callout_box_closed.emit()


	if phase == "end":
		end()

func done_drawing():
	var classification = draw2.classify()
	if classification == "Circle":
		print("Yippee!")

func loop_actions(speeds):
	print("loop_actions")
	
	for x in speeds:
		
		if spelling == false:
			if callout_ended == true:
				action_for_player(x)
				await callout_box_closed 
				if speeds.find(x) == speeds.size()-1:
					print("yipee!")
					callout_done.emit()
func action_for_player(x):
	print("action_for_player")
	callout_ended = false
	var name = x.get_slice(":",0)
	if name != "You":
		name = enemy_stats[0]
	print(name)
	if name == "You":
		var p_action = player_choice
		if p_action.get_slice(":",0) == "Attack":
			var dmg =  (floor((float(Main.player_current_stats[2])/float(enemy_stats[3])) + randi_range(2,3)))
			enemy_stats[1] -= dmg  
			print(enemy_stats[1])
			var box = textbox.instantiate()
			box.finished_displaying.connect(_on_tb_finish)
			add_child(box)
			var attackwordArray = ["punched", "drop kicked the shit out of", "sprayed paint into the eyes of"]
			var attack_word = attackwordArray.pick_random()
			box.display_text("You " + attack_word + " the " + enemy_stats[0] + " for " + str(dmg))
		if p_action.get_slice(":",0) == "Spell": 
			if p_action.get_slice(":",1) == "Fire": 
				callout_ended = false
				Main.player_current_stats[5] -= 3
			
				add_child(draw_surface)
				draw_surface.on_draw_exit.connect(draw_done)
				draw_surface.lineColor = Color(1,0,.35)
				var box2 = textbox.instantiate()
				add_child(box2)
				box2.display_text("Draw as many triangles as possible to deal the most damage!")
				spelling = true
				await get_tree().create_timer(5).timeout
				
				var box = textbox.instantiate()
				box.finished_displaying.connect(_on_tb_finish)
				add_child(box)
			
				var dmg =  (floor(int(float(Main.player_current_stats[2])*(float(spell_count))/float(enemy_stats[3])) + randi_range(3,5)))
				enemy_stats[1] -= dmg  
				box.display_text("You burned the " + enemy_stats[0] + " for " + str(dmg) + " ")
				callout_ended = true
				spelling = false

				draw_surface.queue_free()

	else:
		var words = monster_move.get_slice(":",2)
		if monster_move.get_slice(":",0) == "Attack":
			var dmg = (floor((float(enemy_stats[2])/float(Main.player_current_stats[3])) + randi_range(2,3)))
			Main.player_current_stats[1] -= dmg
			print(Main.player_current_stats[1])
			var box = textbox.instantiate()
			box.finished_displaying.connect(_on_tb_finish)
			add_child(box)
			box.display_text(name + " " + words + " " + str(dmg))
		

	var attacked = null
	var attack = ""


func reset():
	for x in get_children():
		if x is TextBox:
			x.queue_free()
	phase = "player"
	player_choice = ""
	Main.spell_selected = ""
	
func end():
	Main.state = "ow"
	Main.spell_selected = ""
	enemy.queue_free()
	queue_free()

func draw_done():
	if player_choice == "Spell:Fire":
		print(draw_surface.classify())
		if draw_surface.classify() == "Triangle":
			spell_count += 1
			print(draw_surface.classify())
