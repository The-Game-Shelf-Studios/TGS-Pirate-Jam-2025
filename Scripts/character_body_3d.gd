extends CharacterBody3D


const SPEED = 8
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.003

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	if Input.is_action_just_pressed("left_mb") and $camera_rig/Camera3D.current == true:
		$camera_rig/Camera3D.current = false
		$"../Camera3D2".current = true
	elif Input.is_action_just_pressed("left_mb") and $camera_rig/Camera3D.current == false:
		$camera_rig/Camera3D.current = true
		$"../Camera3D2".current = false

	move_and_slide()

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$camera_rig.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		$camera_rig.rotation.x = clamp($camera_rig.rotation.x, -deg_to_rad(89), deg_to_rad(89))
