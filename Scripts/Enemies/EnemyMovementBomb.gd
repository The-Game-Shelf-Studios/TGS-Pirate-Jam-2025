extends CharacterBody3D

@onready var PlayerNode = get_tree().get_first_node_in_group("Player")
@export var SightRange: float = 10
@export var AttackRange: float = 5
@onready var MyPlayerTracker = find_child("PlayerTrackerNode")
@onready var MyDetonationSphere: Area3D = $Area3D
@export var SPEED = 1
@export var DashSpeed = 2
@export var AttackDamage: int
@export var AttackDelay: float = 2.0
@onready var myAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var BombAnimationPlayer: AnimationPlayer = $BombAnimationPlayer
@onready var myAnimTree: AnimationTree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
var LitFuse = false
var isMoving = false
var PlayerSeen = false
var PlayerIsUnobstructed

func _ready() -> void:
	PlayerSeen = false
	
	
	myAnimTree.set("parameters/conditions/Idling", true)
	#print("idle on")

func _process(delta: float) -> void:
	if PlayerNode != null:
		if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
			PlayerSeen = true
			myAnimTree.set("parameters/conditions/Idling", false)
			MoveTowardsPlayer()
		if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
			if !LitFuse:
				TriggerAttackAnimation()
			else:
				MoveTowardsPlayer()
			
		if MyPlayerTracker.PlayerRelativeDistance >= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
			if PlayerSeen:
				myAnimTree.set("parameters/conditions/Idling", false)
				MoveTowardsPlayer()

	if LitFuse:
		if !BombAnimationPlayer.is_playing():
			DetonateBomb()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

func MoveTowardsPlayer() -> void:
	# Get the Player's direction and handle the movement/deceleration.
	velocity = Vector3.ZERO
	if !isMoving:
		isMoving = true
	myAnimTree.set("parameters/conditions/IsMoving", true)
	#print("move on")
	nav_agent.set_target_position(PlayerNode.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	if !LitFuse:
		velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	else:
		velocity = (next_nav_point - global_transform.origin).normalized() * 2
	look_at(PlayerNode.position, Vector3.UP)
	move_and_slide()

func TriggerAttackAnimation() -> void:
	if !LitFuse:
		if isMoving:
			isMoving = false
		myAnimTree.set("parameters/conditions/IsMoving", false)
		#print("Move off")
		myAnimTree.set("parameters/conditions/Idling", true)
		await get_tree().create_timer(AttackDelay, false, false, true).timeout
		LitFuse = true
		#print("Fuse Lit!")
		BombAnimationPlayer.play("BombFuse")
		isMoving = true
 #find some way to represent the lighting of the fuse and then approaching the player

func DetonateBomb() -> void:
	for hit in MyDetonationSphere.get_overlapping_areas():
		if hit.is_in_group("Player"):
			DealDamageToPlayer()
	queue_free()
	pass

func DealDamageToPlayer() -> void:
	print("I Hit!")
	#print("Move on")
	pass
