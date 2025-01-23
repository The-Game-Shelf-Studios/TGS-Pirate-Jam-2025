extends CharacterBody3D


@onready var PlayerNode = get_tree().get_first_node_in_group("Player")
@export var SightRange: float = 10
@export var AttackRange: float = 4
@onready var MyPlayerTracker = find_child("PlayerTrackerNode")
@export var SPEED = 0.5
@export var AttackDamage: int
@export var AttackDelay: float = 2.0
var isAttacking = true
var PlayerSeen = false

func _ready() -> void:
	PlayerSeen = false
	isAttacking = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if PlayerNode != null:
		if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
			PlayerSeen = true
			if !isAttacking:
				MoveTowardsPlayer()
		if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
			if !isAttacking:
				TriggerAttackAnimation()
		if MyPlayerTracker.PlayerRelativeDistance >= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
			if PlayerSeen:
				MoveTowardsPlayer()

func MoveTowardsPlayer() -> void:
	# Get the Player's direction and handle the movement/deceleration.
	look_at(PlayerNode.position, Vector3.UP)
	var direction := Vector3( PlayerNode.position.x - position.x, 0, PlayerNode.position.z - position.z)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()



	

func TriggerAttackAnimation() -> void:
	isAttacking = true
	await get_tree().create_timer(AttackDelay, false, false, true).timeout
	if MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
		DealDamageToPlayer()
	if MyPlayerTracker.PlayerRelativeDistance > AttackRange:
		print("I Missed!")
	isAttacking = false

func DealDamageToPlayer() -> void:
	print("I Hit!")
	pass
