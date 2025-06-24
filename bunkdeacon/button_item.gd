extends Button

@onready var inventory_value = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	Main.item_selected = Main.inventory[inventory_value][0]
	Main.inventory.pop_at(inventory_value)
