extends CharacterBody3D
class_name Player

const SPEED = 13
const JUMP_VELOCITY = 4.5

@onready var model = $Model
@onready var animation = $Model.animation

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Main.move_lock == false:
		var input_dir = Input.get_vector("a", "d", "w", "s")
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			animation.set_current_animation("Run")
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			animation.set_current_animation("Still")
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		if Input.is_action_pressed("w"):
			model.rotation_degrees.y = 180
		if Input.is_action_pressed("s"):
			model.rotation_degrees.y = 0
		if Input.is_action_pressed("a"):
			model.rotation_degrees.y = -90
		if Input.is_action_pressed("d"):
			model.rotation_degrees.y = 90
			
		if Input.is_action_pressed("w") and Input.is_action_pressed("d"):
			model.rotation_degrees.y = 135
		if Input.is_action_pressed("w") and Input.is_action_pressed("a"):
			model.rotation_degrees.y = -135
		if Input.is_action_pressed("s") and Input.is_action_pressed("a"):
			model.rotation_degrees.y = -45
		if Input.is_action_pressed("s") and Input.is_action_pressed("d"):
			model.rotation_degrees.y =45

		move_and_slide()
