extends Node3D
class_name Enemy

@onready var attack_radius = 10
@onready var area = $Area3D
@onready var mesh = $CSGMesh3D
@export var kill_on_flee = false
@export var enem_name: String
@export var enem_sprite: Resource
@export var enem_stats: int
@export var meshy: Resource
@onready var enem_spells = enem_stats
@export var speed: float
var text_box = load("res://textbox.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if meshy != null:
		var meshy = meshy.instantiate()
		meshy.scale = Vector3(2,2,2)

		add_child(meshy)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Main.move_lock == false:
		for x in get_tree().current_scene.get_children():
			if x is Player:
				if self.transform.origin.distance_to(x.position) < attack_radius:
					self.global_rotation.y = self.position.angle_to(x.global_position)+.5
					self.position += (x.position - self.position).normalized() /speed 

func _on_area_3d_area_entered(area):

	if area.get_parent() is Player:
		Main.state = "battle_init"
		Main.move_lock = true
		var anim = load("res://battle_anime.tscn")
		var animate = anim.instantiate()
		add_child(animate) 
		Main.enemy = self
