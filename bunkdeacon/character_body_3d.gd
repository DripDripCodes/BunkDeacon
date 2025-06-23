extends CharacterBody3D
class_name Player

const SPEED = 10.0
const JUMP_VELOCITY = 4.5

@onready var model = $Model
func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
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
