class_name Player extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $FirstPersonCamera/PlayerArms/AnimationPlayer
@onready var first_person_camera: Camera3D = $FirstPersonCamera

@export_category("Movement Settings")
@export var player_speed: float = 5.0
@export var jump_velocity = 4.5

@export_category("Camera Settings")
@export var look_sensitivity: float = .003
@export var fov : float = 80 ## TODO: Connect to camera fov

@export_category("Status Settings")
@export var hp : int = 100
@export var invulerable := false ## FOR TESTING AND MAYBE CUTSCENES

var current_hurt_box : HurtBox ## This will change with "Weapons" you pick up TODO: Change to weapon class

var direction: Vector3 ## Input Direction

static var can_control := true 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Omly allow movement if player can be contolled
	if can_control:
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = jump_velocity
		
		move_player()

# Get player input as Vector2 and parse into a direction to move
func get_input_direction() -> void:
	var input_dir := Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backwards")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

# If player can be controlled, move in input direction
func move_player() -> void:
	get_input_direction()
	
	if direction:
		velocity.x = direction.x * player_speed
		velocity.z = direction.z * player_speed
	else:
		velocity.x = move_toward(velocity.x, 0, player_speed)
		velocity.z = move_toward(velocity.z, 0, player_speed)
	
	#TODO: Add "headbob" to arms 
	
	move_and_slide()

# Called when attacking
func attack() -> void:
	print("ATTACK")
	update_animation("OrcSwing1")

# Called when grabbing an enemy
func grab() -> void:
	print("GRAB")
	update_animation("OrcGrab1")

# Called When throwing goblin
func throw() -> void:
	print("THROW")

# Called when needing to play new player animation 
# Needs string with animations name
func update_animation(new_anim: String) -> void:
	animation_player.play(new_anim)

func _input(event: InputEvent) -> void:
	# Allow input only if player can be controlled
	if can_control:
		# Camera movement
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * look_sensitivity)
			first_person_camera.rotate_x(-event.relative.y * look_sensitivity)
			first_person_camera.rotation.x = clamp(first_person_camera.rotation.x, -deg_to_rad(89), deg_to_rad(89))
		
		# Handle ESC
		if event.is_action_pressed("Esc"):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE # **TESTING** CHANGE BEFORE SHIPPING
		
		# Handle Attack
		if event.is_action_pressed("Attack"):
			attack()
		# Handle Grab
		if event.is_action_pressed("Grab"):
			grab()
		# Handle Throw
		if event.is_action_pressed("Throw"):
			throw()

# Reset Animation
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "OrcPoses":
		animation_player.play("OrcPoses", -1,1, true) ## This sets it to the final frame of the OrcPoses anim
