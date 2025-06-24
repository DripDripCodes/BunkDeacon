extends Node3D
class_name Enemy

@onready var attack_radius = 1000
@onready var area = $Area3D
@onready var mesh = $CSGMesh3D
@export var enem_name: String
@export var enem_sprite: Resource
@export var enem_stats: int
@export var meshy: Resource
@onready var enem_spells = enem_stats

var text_box = load("res://textbox.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
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
					print(self.position.angle_to(x.global_position))
					self.global_rotation.y = self.position.angle_to(x.global_position)+.5
				
					self.position += (x.position - self.position).normalized() /20


func _on_area_3d_area_entered(area):
	if area.get_parent() is Player:
		Main.state = "battle"
		Main.enemy = self
