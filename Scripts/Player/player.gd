class_name Player extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $FirstPersonCamera/PlayerArms/AnimationPlayer
@onready var first_person_camera: Camera3D = $FirstPersonCamera
@onready var GoblinAttachmentNode: Node3D = $FirstPersonCamera/PlayerArms/OrcSkeleton_Object/Skeleton3D/BoneAttachment3D/GoblinAttatchmentNode
@onready var WeaponGoblinBow = $FirstPersonCamera/PlayerArms/OrcSkeleton_Object/Skeleton3D/BoneAttachment3D/GoblinAttatchmentNode/WeaponGoblinBow
@onready var WeaponGoblinSword = $FirstPersonCamera/PlayerArms/OrcSkeleton_Object/Skeleton3D/BoneAttachment3D/GoblinAttatchmentNode/WeaponGoblinSword
@onready var WinnerLabel = $WinnerLabel
@onready var LoserLabel = $LoserLabel
@onready var ReturnToMainMenuTimer = $ReturnToMainMenuTimer
@export var MeleeAttackRange: float = 3.0
@export var MeleeDamage = 2
@export var WeaponDurability: int = 0
var HeldWeapon
@export_category("Movement Settings")
@export var player_speed: float = 5.0
@export var jump_velocity = 4.5
@export_category("Camera Settings")
@export var look_sensitivity: float = .003
@export var fov : float = 80 ## TODO: Connect to camera fov

@export_category("Status Settings")
@export var Health : int = 50
@export var invulerable := false ## FOR TESTING AND MAYBE CUTSCENES
@onready var HealthBar = $HealthBar
@onready var DurabilityBar = $DurabilityBar
var isDead : bool = false
var PickedUpGobbo: int = 0
var GameWon = false
@export var isHoldingWeapon: bool = false

@onready var current_hurt_box : HurtBox = $HurtBox ## This will change with "Weapons" you pick up TODO: Change to weapon class

var direction: Vector3 ## Input Direction

static var can_control := true 

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	current_hurt_box.damage = MeleeDamage
	WeaponGoblinBow.visible = false
	WeaponGoblinSword.visible = false
	WinnerLabel.visible = false
	LoserLabel.visible = false

func _process(delta: float) -> void:
	set_health_bar()
	if isDead:
		Die()
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

func set_health_bar() -> void:
	HealthBar.value = Health
	DurabilityBar.value = WeaponDurability
	pass

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
	if isHoldingWeapon:
		for hit in current_hurt_box.get_overlapping_areas():
			print("target found in hurtbox")
			if hit.is_in_group("Enemy"):
				print("Enemy Found In Hurtbox")
				current_hurt_box.DamageHitBox(hit)
		#print("ATTACK")
		WeaponDurability = WeaponDurability - 1
		UpdateHeldWeaponAnim()
		
		update_animation("OrcSwing1")
	else:
		grab()

func UpdateHeldWeaponAnim() -> void:
	HeldWeapon.ImpactTaken()
	if WeaponDurability <= 0:
		HeldWeapon.BreakWeapon()
		HeldWeapon = null
		WeaponGoblinBow.visible = false
		WeaponGoblinSword.visible = false
		isHoldingWeapon = false
		PickedUpGobbo = 0

# Called when grabbing an enemy
func grab() -> void:
	if !isHoldingWeapon:
		CheckForLookedAtEnemy()
		print("GRAB")
		update_animation("OrcGrab1")
	else:
		print("Hand is full!")

func CheckForLookedAtEnemy() -> void:
	var mousePos = get_viewport().get_mouse_position()
	var from = Vector3(self.position.x, 1, self.position.z)
	var to = from + first_person_camera.project_ray_normal(mousePos) * 5
	var space = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.create(from, to)
	var result = space.intersect_ray(rayQuery)
	if result.size() > 1:
		print("Target Struck")
		if result.collider.is_in_group("Enemy"):
			PickupTargetGobbo(result.collider)
	pass

func PickupTargetGobbo(targetGobbo: Object) -> void:
	targetGobbo.GetPickedUp()
	SpawnWeaponInHand()
	pass
# Called When throwing goblin

func SpawnWeaponInHand() -> void:
	isHoldingWeapon = true
	WeaponDurability = 4
	if PickedUpGobbo == 1:
		WeaponGoblinSword.visible = true
		HeldWeapon = WeaponGoblinSword
	if PickedUpGobbo == 2:
		WeaponGoblinBow.visible = true
		HeldWeapon = WeaponGoblinBow
	if HeldWeapon != null:
		HeldWeapon.ProtestPickup()
	#var arrowinst = Arrow.instantiate()
	#arrowinst.position = find_child("BowPoint").position
	#arrowinst.Target = PlayerNode.position
	#arrowinst.Father = self
	#add_child(arrowinst)
	
	pass

func throw() -> void:
	print("THROW")

# Called when needing to play new player animation 
# Needs string with animations name
func update_animation(new_anim: String) -> void:
	animation_player.play(new_anim)

func Die() -> void:
	can_control = false
	LoserLabel.visible = true
	ReturnToMainMenuTimer.start()
	print("Player Died")

func TakeDamageFromEnemy(damage: int):
	Health = Health - damage
	if Health <= 0:
		isDead = true

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

func WinGame() -> void:
	WinnerLabel.visible = true
	ReturnToMainMenuTimer.start()
	pass

# Reset Animation
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name != "OrcPoses":
		animation_player.play("OrcPoses", -1,1, true) ## This sets it to the final frame of the OrcPoses anim


func _on_return_to_main_menu_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")
	pass # Replace with function body.
