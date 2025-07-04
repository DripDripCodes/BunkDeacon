
extends CanvasLayer
class_name Battle
#images
@onready var background = $Background
@onready var enem_sprite = $"Enemy Sprite"
@onready var music = $Music
@onready var sounds = $Sounds

var spells = preload("res://spell_box.tscn")
var textbox = load("res://textbox_battle.tscn")
var spellbox = preload("res://textbox_spells.tscn")
var bkg_image = load("res://backgroun_1.tscn")
var main_menu = load("res://menu_box.tscn")
var items = load("res://item_box.tscn")

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

#spell specific variables
var bubble_timer = Timer.new()
var bubble_size = 0
var bubbled = [0,0]

var callout_ended = true
signal callout_done
signal callout_box_closed
# Called when the node enters the scene tree for the first time.
func _ready():
	


	draw2.on_draw_exit.connect(done_drawing)
	var mm = main_menu.instantiate()
	add_child(mm)
	mm.fight_button.button_down.connect(main_fight_down)
	mm.item_button.button_down.connect(main_item_down)
	mm.spray_button.button_down.connect(main_spray_down)
	mm.flee_button.button_down.connect(main_flee_down)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Main.player_current_stats[1] <= 0 and phase != "loss" and phase != "end_loss":
		phase = "loss"
		
	if phase == "loss":
		var box = textbox.instantiate()
		box.finished_displaying.connect(_on_tb_finish)
		add_child(box)
		box.display_text("You lose...")
		phase = "end_loss"
		loss()
		
	if phase == "victory":
		print("Victory")
		var box = textbox.instantiate()
		box.finished_displaying.connect(_on_tb_finish)
		add_child(box)
		if Main.kill_on_talk == true:
			if Main.talkee != null:
				Main.talkee.queue_free()
				if get_tree().current_scene != null and get_tree().current_scene is not Gesture:
					
					match enemy_stats[0]:
						"Frankzi Goon":
							if get_tree().current_scene.namae == "Alley":
								Main.goon_alley_killed = true

		box.display_text("You win! You gained " + str(enemy_stats[5]) + " xp!")

		Main.player_xp += enemy_stats[5]
		music.stream = preload("res://Victory.wav")
		music.play()
		
		phase = "end"
	if phase == "init":

		if enemy.enem_sprite != null:
			enem_sprite.texture = enemy.enem_sprite
		
		for x in Monster.basic_monsters[enemy.enem_stats]:
			enemy_stats.append(x)
		print(enemy.enem_spells)
		enemy_moves = Monster.monster_moves[enemy.enem_stats]
		print(enemy_moves)
		
		en_name = enemy_stats[0]

		$ProgressBar.value = (enemy_stats[1]/Monster.basic_monsters[enemy.enem_stats][1])*100
		print(en_name)
		match en_name:
	
			"Frankzi Goon":
				print()
				music.stream = load("res://Alarm.mp3")
				music.volume_db = -6
				music.play()
			_:
	
				music.stream = load("res://Battle.mp3")
				music.play()
		match en_name:
			"Frankzi Goon":
				var bg_image = load("res://background_2.tscn").instantiate()
				background.add_child(bg_image)
			_:
				var bg_image = bkg_image.instantiate()
				background.add_child(bg_image)
				

		var box = textbox.instantiate()
		box.finished_displaying.connect(_on_tb_finish)
		add_child(box)
		box.display_text(en_name + " approaches! ")
		phase = "player"
	if phase == "player":
		$ProgressBar.value = (enemy_stats[1]/Monster.basic_monsters[enemy.enem_stats][1])*100
		if Main.spell_selected != "":
			player_choice = Main.spell_selected
			print(player_choice)
			phase = "monster"
		if Main.item_selected != "":
			player_choice = "Item:" + Main.item_selected
			phase = "monster"
	if phase == "monster":
		$ProgressBar.value = (enemy_stats[1]/Monster.basic_monsters[enemy.enem_stats][1])*100
		print(enemy_moves)
		monster_move = enemy_moves[randi_range(0,enemy_moves.size()-1)]
		
		phase = "callout"
	if phase == "callout":
		$ProgressBar.value = (enemy_stats[1]/Monster.basic_monsters[enemy.enem_stats][1])*100
		var speeds = []
		if Main.player_current_stats[4] > enemy_stats[4]:
			speeds.append("You:"+str(Main.player_current_stats[4]))
			speeds.append(str(enemy_stats[4]))
		else:
			speeds.append(str(enemy_stats[4]))
			speeds.append("You:"+str(Main.player_current_stats[4]))
		phase = "calling"
		loop_actions(speeds)
		await callout_done
		if enemy_stats[1] <= 0:
			phase = "victory"
		else:
			spelling = false
			callout_ended = true
			Main.spell_selected = ""
			Main.item_selected =""
			
			phase = "player"
			

func main_fight_down():
	if phase == "player":
		player_choice = "Attack:Player"
		phase = "monster"
		print("Fight")
func main_item_down():
	if phase == "player":
		var ib = items.instantiate()
		add_child(ib)
func main_spray_down():
	if phase == "player":
		var spellbook = spells.instantiate()
		add_child(spellbook)
		print("Spray")
func main_flee_down():
	if phase == "player":
		if enemy.fleeable == true:
			Main.state = "ow"
			queue_free()
			if enemy.kill_on_flee == true:
				enemy.queue_free()
		else:
			sounds.stream = load("res://Wrong.mp3")
			sounds.play()
	
func _on_tb_finish():

	if phase == "calling":
		if spelling == false:
			for x in get_children():
				if x is Battle_Textbox:
					if enemy_stats[1] <= 0:
						phase = "victory"
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
	print(speeds)
	$ProgressBar.value = (enemy_stats[1]/Monster.basic_monsters[enemy.enem_stats][1])*100
	for x in speeds:
		print(x)
		if spelling == false:
			print("spelling")
			print(callout_ended)
			if callout_ended == true:
				print("callout_ended")
				if phase != "end" and phase != "victory":
					action_for_player(x)
					await callout_box_closed 
					if speeds.find(x) >= speeds.size()-1:
						print()
						print("yipee!")
						callout_done.emit()	
func action_for_player(x):
	print(player_choice)

	var name = x.get_slice(":",0)
	if name != "You":
		name = enemy_stats[0]
	
	if name == "You":
		var dmg
		var p_action = player_choice
		if p_action.get_slice(":",0) == "Attack":
			if bubbled[1] == 0:
				dmg =  (floor((float(Main.player_current_stats[2])/float(enemy_stats[3])) + randi_range(2,3)))
			else:
				dmg =  (floor((float(Main.player_current_stats[2])/(float(enemy_stats[3])/2)) + randi_range(5,6)))
				bubbled[1] != 0
				
				
			enemy_stats[1] -= dmg  
			print(enemy_stats[1])
			var box = textbox.instantiate()
			box.finished_displaying.connect(_on_tb_finish)
			add_child(box)
			var attackwordArray = ["punched", "drop kicked the shit out of", "sprayed paint into the eyes of"]
			var attack_word = attackwordArray.pick_random()
			box.display_text("You " + attack_word + " the " + enemy_stats[0] + " for " + str(int(dmg))+"                        ")

		if p_action.get_slice(":",0) == "Item":
			spelling = false
			match  p_action.get_slice(":",2):
				"Heal":
					print("healing")
					var heal = int(p_action.get_slice(":",3))
					var box2 = textbox.instantiate()
					box2.finished_displaying.connect(_on_tb_finish)
					add_child(box2)
					if Main.player_current_stats[1] == Main.player_stats[1]:
						box2.display_text("HP is already maxxed out!")
					if Main.player_current_stats[1] + heal >= Main.player_stats[1] and Main.player_current_stats[1] != Main.player_stats[1]:
						box2.display_text("You used the " +  p_action.get_slice(":",1) + " and your HP maxxed out!!")
						Main.player_current_stats[1] = Main.player_stats[1]
					if Main.player_current_stats[1] + heal < Main.player_stats[1]:
						box2.display_text("You used the " +  p_action.get_slice(":",1) + " and gained "+ str(heal) + " HP!!")
						Main.player_current_stats[1] += heal
				_:
					pass
		if p_action.get_slice(":",0) == "Spell": 
			match p_action.get_slice(":",1):
				"Fire":
					callout_ended = false
					Main.player_current_stats[5] -= 3
					var draw_surface = draw.instantiate()
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
				
					dmg =  (floor(int(float(Main.player_current_stats[2])*(float(spell_count)/2)/float(enemy_stats[3])) + randi_range(0,1)))
					enemy_stats[1] -= dmg  
					spell_count = 0
					box.display_text("You burned the " + enemy_stats[0] + " for " + str(dmg) + " ")
					callout_ended = true
					spelling = false

					draw_surface.queue_free()
				"Bubble":
					callout_ended = false
					Main.player_current_stats[5] -= 6
					var draw_surface = draw.instantiate()
					add_child(draw_surface)
					draw_surface.on_draw_exit.connect(draw_done)
					draw_surface.lineColor = Color(.2,.5,1)
					var box2 = textbox.instantiate()
					add_child(box2)
					box2.display_text("Draw a circle!")
					spelling = true
					bubble_timer.wait_time = 2
					await bubble_timer.timeout
					var box3 = textbox.instantiate()
					add_child(box3)
					box3.display_text("Draw another circle!")
					bubble_timer.wait_time = 2
					await bubble_timer.timeout
					var box4 = textbox.instantiate()
					add_child(box4)
					box4.display_text("Draw a final circle!")
					bubble_timer.wait_time = 2
					await bubble_timer.timeout
					var box = textbox.instantiate()
					box.finished_displaying.connect(_on_tb_finish)
					add_child(box)
					$"Enemy Sprite/AnimationPlayer".current_animation= "bubbled"
					$"Enemy Sprite/AnimationPlayer".play()
					box.display_text("You entrapped the enemy in a bubble for 4 damage! Physical attacks do more damage!")
					enemy_stats[1] -= 4  
					bubbled[1] = 1
					callout_ended = true
					spelling = false

					draw_surface.queue_free()
				_:
					var box = textbox.instantiate()
					box.finished_displaying.connect(_on_tb_finish)
					add_child(box)
					box.display_text("Aaron hasn't put in this spell yet dummy!")
					spelling = false
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
	await get_tree().create_timer(1).timeout
	Main.state = "ow"
	Main.spell_selected = ""
	if enemy!= null:
		enemy.queue_free()
	queue_free()
func loss():
	await get_tree().create_timer(2).timeout
	Main.state = "ow"
	Main.spell_selected = ""
	Main.player_current_stats[1] = 1
	get_tree().reload_current_scene()
	queue_free()


func draw_done():
	var draw_surface
	match player_choice:
		"Spell:Fire":
			for x in get_children():
				if x is Gesture:
					draw_surface = x
			if draw_surface.classify() == "Triangle":
				spell_count += 1 
				sounds.stream = load("res://Pickup2.wav")
				sounds.play()

		"Spell:Bubble":
			for x in get_children():
				if x is Gesture:
					draw_surface = x
			if draw_surface.classify() == "SCircle":
				bubble_timer.timeout.emit()
				sounds.stream = load("res://Pickup2.wav")
				sounds.play()
