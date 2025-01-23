class_name Player extends CharacterBody3D

@export_category("Movement Settings")
@export var player_speed: float = 5.0
@export var jump_velocity = 4.5

@export_category("Camera Settings")
@export var look_sensitivity: float = .003
@onready var first_person_camera: Camera3D = $FirstPersonCamera

var direction: Vector3 ## Input Direction

var can_control := true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
		
	# Handle Esc
	if Input.is_action_just_pressed("Esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	move_player()

# Get player input and parse into a direction to move
func get_input_direction() -> void:
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backwards")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

# If player can be controlled, move in input direction
func move_player() -> void:
	if can_control:
		
		get_input_direction()
		
		if direction:
			velocity.x = direction.x * player_speed
			velocity.z = direction.z * player_speed
		else:
			velocity.x = move_toward(velocity.x, 0, player_speed)
			velocity.z = move_toward(velocity.z, 0, player_speed)
		
		move_and_slide()

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		first_person_camera.rotate_x(-event.relative.y * look_sensitivity)
		first_person_camera.rotation.x = clamp(first_person_camera.rotation.x, -deg_to_rad(89), deg_to_rad(89))
