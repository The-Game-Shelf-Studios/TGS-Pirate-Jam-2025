extends CharacterBody3D

@onready var PlayerNode = get_tree().get_first_node_in_group("Player")
@export var SightRange: float = 10
@export var AttackRange: float = 2
@onready var MyPlayerTracker = find_child("PlayerTrackerNode")
@export var SPEED = 1
@export var AttackDamage: int
@export var AttackDelay: float = 2.0
@onready var myAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var myAnimTree: AnimationTree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
var isMoving = false
var isAttacking = true
var PlayerSeen = false
var PlayerIsUnobstructed

func _ready() -> void:
	PlayerSeen = false
	isAttacking = false
	
	myAnimTree.set("parameters/conditions/Idling", true)
	print("idle on")

func _process(delta: float) -> void:
	if PlayerNode != null:
		if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
			PlayerSeen = true
			myAnimTree.set("parameters/conditions/Idling", false)
			if !isAttacking:
				MoveTowardsPlayer()
		if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
			if !isAttacking && !isMoving:
				TriggerAttackAnimation()
		if MyPlayerTracker.PlayerRelativeDistance >= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
			if PlayerSeen:
				myAnimTree.set("parameters/conditions/Idling", false)
				MoveTowardsPlayer()
	pass

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
	print("move on")
	
	nav_agent.set_target_position(PlayerNode.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(PlayerNode.position, Vector3.UP)
	move_and_slide()

func TriggerAttackAnimation() -> void:
	if isMoving:
		isMoving = false
	isAttacking = true
	myAnimTree.set("parameters/conditions/IsMoving", false)
	print("Move off")
	myAnimTree.set("parameters/conditions/Attack1", true)
	print("attack on")



func DealDamageToPlayer() -> void:
	print("I Hit!")
	myAnimTree.set("parameters/conditions/IsMoving", true)
	print("Move on")
	pass


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if myAnimTree["parameters/conditions/Attack1"] == true:
		myAnimTree.set("parameters/conditions/Attack1", false)
		print("Attack off")
		if MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
			DealDamageToPlayer()
		if MyPlayerTracker.PlayerRelativeDistance > AttackRange:
			print("I Missed!")
			myAnimTree.set("parameters/conditions/IsMoving", true)
			print("Move on")
		isAttacking = false
