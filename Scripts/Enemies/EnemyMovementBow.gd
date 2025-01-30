extends CharacterBody3D


@onready var PlayerNode = get_tree().get_first_node_in_group("Player")
@export var SightRange: float = 10
@export var AttackRange: float = 6
@export var EscapeRange: float = 3
@onready var MyPlayerTracker = find_child("PlayerTrackerNode")
@export var SPEED = 1
@export var ProjectileSpeed: float = 0.5
@export var AttackDamage: int
@export var AttackDelay: float = 2.0
@export var CheckBehindRayLength: float = 100
@onready var myAnimationPlayer: AnimationPlayer = $AnimationPlayer
@onready var myAnimTree: AnimationTree = $AnimationTree
@onready var nav_agent = $NavigationAgent3D
var PlayerTargetPosition
var EscapePoint: Vector3
var isMoving = false
var isAttacking = true
var PlayerSeen = false
var PlayerIsUnobstructed
var Arrow = preload("res://Scenes/Characters/Enemies/projectiles/GobboArrow.tscn")

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
		if MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
			PlayerSeen = true
			if MyPlayerTracker.PlayerRelativeDistance >= EscapeRange:
				if !isAttacking:
					TriggerAttackAnimation()
			if MyPlayerTracker.PlayerRelativeDistance < EscapeRange:
				if position.distance_to(EscapePoint) < 2:
					if !isAttacking:
						TriggerAttackAnimation()
				if position.distance_to(EscapePoint) >= 2:
					MoveAwayFromPlayer()
		if MyPlayerTracker.PlayerRelativeDistance >= SightRange:
			if PlayerSeen:
				myAnimTree.set("parameters/conditions/Idling", false)
				MoveTowardsPlayer()
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var space_state = get_world_3d().direct_space_state
	FindEscapePoint(space_state)
		
	

func MoveTowardsPlayer() -> void:
	# Get the Player's direction and handle the movement/deceleration.
	velocity = Vector3.ZERO
	if !isMoving:
		isMoving = true
	myAnimTree.set("parameters/conditions/IsMoving", true)
	#print("move on")
	
	nav_agent.set_target_position(PlayerNode.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(PlayerNode.position, Vector3.UP)
	move_and_slide()

func FireArrow() -> void:
	var arrowinst = Arrow.instantiate()
	arrowinst.position = find_child("BowPoint").position
	arrowinst.Target = PlayerNode.position
	arrowinst.Father = self
	add_child(arrowinst)
	
func MoveAwayFromPlayer() -> void:
	#raycast in the opposite direction to the player, find a point abt 1 unit from whatever you collide with and walk towards it until you are either within 1 unit of that point
	#or the player is far enough away. if you reach the within 1 unit of that point spot then turn around and attack the player anyways.
	velocity = Vector3.ZERO
	if !isMoving:
		isMoving = true
	myAnimTree.set("parameters/conditions/IsMoving", true)
	#print("move on")
	
	nav_agent.set_target_position(EscapePoint)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	look_at(EscapePoint, Vector3.UP)
	move_and_slide()
	pass

func FindEscapePoint(space_state: PhysicsDirectSpaceState3D) -> void:
	#raycast to a point opposite the player's direction, find a point abt 1 unit closer to you than the final position of whatever you collide with.
	#we can do this by raycasting to the final point then adding to it a normalized vector pointing to the player and that should give us a point that is one unit closer
	var PlayerDirection = Vector3(PlayerNode.position.x - position.x, 0, PlayerNode.position.z - position.z)
	var query = PhysicsRayQueryParameters3D.create(Vector3(position.x, 0, position.z), -PlayerDirection.normalized() * CheckBehindRayLength)
	#print(Vector3(-PlayerNode.position.x, 0, -PlayerNode.position.z).normalized() * CheckBehindRayLength)
	EscapePoint = space_state.intersect_ray(query).position + Vector3(PlayerNode.position.x, 0, PlayerNode.position.z).normalized()
	#print(space_state.intersect_ray(query).position)
	#print("Escape point", EscapePoint)
	

func TriggerAttackAnimation() -> void:
	if isMoving:
		isMoving = false
	isAttacking = true
	look_at(PlayerNode.position, Vector3.UP)
	myAnimTree.set("parameters/conditions/IsMoving", false)
	print("Move off")
	myAnimTree.set("parameters/conditions/IsAttacking", true)
	print("attack on")
	FireArrow()

func Arrow_Struck():
	DealDamageToPlayer()

func DealDamageToPlayer() -> void:
	print("I Hit!")
	myAnimTree.set("parameters/conditions/IsMoving", true)
	print("Move on")
	pass


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if myAnimTree["parameters/conditions/IsAttacking"] == true:
		myAnimTree.set("parameters/conditions/IsAttacking", false)
		print("Attack off")
		#if MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
			#DealDamageToPlayer()
		#if MyPlayerTracker.PlayerRelativeDistance > AttackRange:
			#print("I Missed!")
		myAnimTree.set("parameters/conditions/IsMoving", true)
		print("Move on")
		isAttacking = false
