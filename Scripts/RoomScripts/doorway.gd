class_name Doorway extends Node3D

enum DoorwayDirection {North,East,South,West}

@onready var collider: CollisionShape3D = $DoorCollider
@onready var door: MeshInstance3D = $Door
@onready var wall: MeshInstance3D = $Wall

@export var myDirection: DoorwayDirection
@export var doorwayActive: bool = false

var doorLocked: bool = true

func _ready() -> void:
	#setupDoorway(doorwayActive) #TODO: Remove this after testing
	if !doorwayActive:
		wall.visible = true
		door.visible = false
	pass

## Setup doorway as either a door or a wall
func setupDoor() -> void:
	doorwayActive = true
	wall.visible = false
	door.visible = true

## Called when opening doors in room
func unlockDoor() -> void:
	doorLocked = false
	door.visible = false #TODO: Anim for door opening?
	collider.disabled = true

func _on_exit_body_entered(body: Node3D) -> void:
	if !doorLocked:
		#TODO: Initiate Transfer to next room?
		pass
	pass
