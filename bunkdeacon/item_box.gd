extends Control

@onready var grid  = $Panel/GridContainer

var item_button = load("res://button_item.tscn")
var i = 0
var lock = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	i = 0
	if lock == false:
		for x in Main.inventory:
			if x != null:
				var ib = item_button.instantiate()
				var y = x[0]
				ib.text = y.get_slice(":",0)
				ib.inventory_value = Main.inventory[i]
				ib.button_down.connect(item_popped)
				grid.add_child(ib)
				i+=1
		lock = true

func item_popped(): 
	queue_free()
	for x in grid.get_children():
		x.queue_free()
		lock = false
		


func _on_button_button_down():
	queue_free()

	
