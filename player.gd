extends CharacterBody3D

const SPEED = 1.35
const JUMP_VELOCITY = 3
const MOUSE_SENS = 0.4
const TURN_SENS = 0.03

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot : Vector2

var frozen : bool = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _physics_process(delta):
	if frozen:
		return
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		print("Jump!")
		velocity.y = JUMP_VELOCITY
		
	rotation_degrees.y = look_rot.y
	$cam.rotation_degrees.x = look_rot.x

	if Input.is_action_pressed("player_l_turn"):
		rotate_y(TURN_SENS)
	if Input.is_action_pressed("player_r_turn"):
		rotate_y(-TURN_SENS)

	var input_dir = Input.get_vector("player_left", "player_right", 
		"player_forward", "player_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * MOUSE_SENS)
		look_rot.x -= (event.relative.y * MOUSE_SENS)
		#look_rot.x = clamp(look_rot.x, -80, 80)
