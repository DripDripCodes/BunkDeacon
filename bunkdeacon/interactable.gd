extends Node3D
class_name Interactable

@onready var area = $Area3D
@onready var mesh = $CSGMesh3D
@export var meshy: Resource
@onready var enemy = $Enemy
@onready var click_sprite = $Sprite3D

@export var dialogue_tree: Resource
@export var enemy_sprite: Resource
@export var enemy_stats: int
@export var enem_mesh: Resource
@export var kill_on_flee = false
var entered = false
@export var dialogue = ""
var text_box = load("res://textbox.tscn")
var talked_to = false
@export var battle = false
@export var kill_on_talk = false
@export var activate_on_step = false
@export var before_battle_text: String
@export var after_battle_text: String

var end = false
# Called when the node enters the scene tree for the first time.

func _ready():
	enemy.enem_sprite = enemy_sprite
	enemy.enem_stats = enemy_stats

	enemy.meshy = enem_mesh
	enemy.position.y = 100000
	click_sprite.visible = false

	if meshy != null:
		var meshy = meshy.instantiate()
		meshy.scale = Vector3(2,2,2)
		add_child(meshy)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entered and Input.is_action_just_pressed("z") and Main.state != "talking" and talked_to == false and activate_on_step == false:
		Main.state = "talking"
		Main.talkee = self
		Main.before_battle_text = before_battle_text
		Main.after_battle_text = after_battle_text
		Main.kill_on_talk = kill_on_talk
		talked_to = true
		if dialogue != "":
			DialogueManager.show_example_dialogue_balloon(dialogue_tree,dialogue)
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_tree,"start")
	
		click_sprite.visible = false
	if entered and activate_on_step  and Main.state != "talking" and talked_to == false :
		Main.state = "talking"
		Main.talkee = self
		Main.before_battle_text = before_battle_text
		Main.after_battle_text = after_battle_text
		Main.kill_on_talk = kill_on_talk
		talked_to = true
		if dialogue != "":
			DialogueManager.show_example_dialogue_balloon(dialogue_tree,dialogue)
		else:
			DialogueManager.show_example_dialogue_balloon(dialogue_tree,"start")
	
		click_sprite.visible = false
	if end == true:
		if battle == true:
			for x in get_tree().current_scene.get_children():
				if x is Player:
					if enemy!=null:
						enemy.area.global_position = x.global_position

	for x in get_tree().current_scene.get_children():
		if x is Player:
			$Sprite3D.rotation = x.get_child(1).rotation
func _on_area_3d_area_entered(area):
	if area.get_parent() is Player:
		entered = true
		click_sprite.visible = true

func _on_area_3d_area_exited(area):
	if area.get_parent() is Player:
		entered = false
		talked_to = false
		click_sprite.visible = false
