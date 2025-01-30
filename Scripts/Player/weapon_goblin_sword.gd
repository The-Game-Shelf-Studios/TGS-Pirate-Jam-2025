extends Node3D

var isConscious = true
@onready var myAnimationPlayer = $AnimationPlayer
@onready var myAnimationTree = $AnimationTree
@onready var AngerMouth = $GoblinTemplate_Skeleton/Skeleton3D/AngryMouth_Object
@onready var AngerEye = $GoblinTemplate_Skeleton/Skeleton3D/Eyes_Object
@onready var AngerBrow = $GoblinTemplate_Skeleton/Skeleton3D/AngryEyebrows_Object
@onready var DeadEye = $GoblinTemplate_Skeleton/Skeleton3D/DeathEyes_Object
@onready var DeadMouth =$GoblinTemplate_Skeleton/Skeleton3D/DeathMouth_Object
@onready var DeadBrow =$GoblinTemplate_Skeleton/Skeleton3D/NeutralEyebrows_Object


func _ready() -> void:
	AngerMouth.visible = true
	AngerEye.visible = true
	AngerBrow.visible = true
	DeadEye.visible = false
	DeadMouth.visible = false
	DeadBrow.visible = false
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	pass

func ImpactTaken() -> void:
	if isConscious:
		SetUnconscious()


func BreakWeapon() -> void:
	isConscious = true
	AngerMouth.visible = true
	AngerEye.visible = true
	AngerBrow.visible = true
	DeadEye.visible = false
	DeadMouth.visible = false
	DeadBrow.visible = false
	myAnimationTree.set("parameters/conditions/IsDead", false)

func SetUnconscious() -> void:
	isConscious = false
	AngerMouth.visible = false
	AngerEye.visible = false
	AngerBrow.visible = false
	DeadEye.visible = true
	DeadMouth.visible = true
	DeadBrow.visible = true
	myAnimationTree.set("parameters/conditions/IsDead", true)
	pass

func StartSwingAnimation() -> void:
	
	pass
