extends CharacterBody3D


@onready var PlayerNode = get_tree().get_first_node_in_group("Player")
@export var SightRange: float = 12
@export var AttackRange: float = 6
@onready var MyPlayerTracker = find_child("PlayerTrackerNode")
@export var SPEED = 0.5
@export var ChargeSpeed = 1.5
@export var AttackDamage: int
@export var AttackDelay: float = 2.0
@export var AttackCooldownTime: float = 0.5
var PlayerPositionForAttack: Vector3
var PausedForAttack = true
var PlayerSeen = false
var isAttacking = false
var PlayerHasBeenHit = false

func _ready() -> void:
	PlayerSeen = false
	PausedForAttack = false

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if PlayerNode != null:

		if !PausedForAttack && isAttacking:
			ChargeToPlayer()
		else:
			if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
				PlayerSeen = true #if player is in view pursue them
				if !PausedForAttack:
					MoveTowardsPlayer()
			if MyPlayerTracker.PlayerRelativeDistance <= SightRange && MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
				if !PausedForAttack: #if player is in range for an attack, wind up a dash
					TriggerAttackAnimation()
			if MyPlayerTracker.PlayerRelativeDistance >= SightRange && MyPlayerTracker.PlayerRelativeDistance >= AttackRange:
				if PlayerSeen: #if player is out of sight range but has already been detected pursue them anyways.
					if !PausedForAttack:
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

func ChargeAttack() -> void: #position facing towards player wait for attack delay and then fire an attack
	PlayerPositionForAttack = PlayerNode.position
	look_at(PlayerPositionForAttack, Vector3.UP)
	isAttacking = true
	await get_tree().create_timer(AttackDelay, false, false, true).timeout


func ChargeToPlayer() -> void: #rush the player at a higher speed than normal movement, if we collide we deal damage, if we dont, exit this state after reaching the player's last position
	if PlayerHasBeenHit:
		await get_tree().create_timer(1, false, false, true).timeout
		ExitDash()
	if Vector3(position.x, 0, position.z) <= Vector3(PlayerPositionForAttack.x + 0.1, 0, PlayerPositionForAttack.z + 0.1) && Vector3(position.x, 0, position.z) >= Vector3(PlayerPositionForAttack.x - 0.1, 0, PlayerPositionForAttack.z - 0.1):
		if !PlayerHasBeenHit:
			print("Dash Missed!")
		PlayerHasBeenHit = false
		ExitDash()
		
	else:
		var direction := Vector3(PlayerPositionForAttack.x - position.x, 0, PlayerPositionForAttack.z - position.z)
		if direction:
			velocity.x = direction.x * ChargeSpeed
			velocity.z = direction.z * ChargeSpeed
		else:
			velocity.x = move_toward(velocity.x, 0, ChargeSpeed)
			velocity.z = move_toward(velocity.z, 0, ChargeSpeed)
	move_and_slide()
	
func ExitDash() -> void:
	isAttacking = false
	PlayerHasBeenHit = false
	await get_tree().create_timer(AttackCooldownTime, false, false, true).timeout

func TriggerAttackAnimation() -> void:
	PausedForAttack = true
	await get_tree().create_timer(AttackDelay, false, false, true).timeout
	if MyPlayerTracker.PlayerRelativeDistance <= AttackRange:
		ChargeAttack()
	if MyPlayerTracker.PlayerRelativeDistance > AttackRange:
		print("PlayerMoved!")
	PausedForAttack = false

func DealDamageToPlayer() -> void:
	print("I Hit!")
	pass


func _on_overlap_area_body_entered(body: Node3D) -> void:
	if isAttacking:
		if body.is_in_group("Player"):
			if PlayerHasBeenHit == false:
				PlayerHasBeenHit = true
				DealDamageToPlayer()
				
	pass # Replace with function body.
