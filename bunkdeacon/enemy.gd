extends Node3D

@onready var attack_radius = 10000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for x in get_tree().current_scene.get_children():
		if x is Player:
			print(x.position)
			if self.transform.origin.distance_to(x.position) < attack_radius:
				self.position += (x.position - self.position).normalized() /20
