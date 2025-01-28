class_name Weapon extends Node3D

enum WeaponType { SWORD, SPEAR, RANGED, BOMB }

@onready var hurt_box: HurtBox = $HurtBox # IMPORTANT: DAMAGE VALUE IS SET IN HURTBOX INSPECTOR

# Gobbo Expression Objects
@onready var angry_eyebrows: BoneAttachment3D = $SwordGoblin/GoblinTemplate_Skeleton/Skeleton3D/AngryEyebrows_Object
@onready var angry_mouth: BoneAttachment3D = $SwordGoblin/GoblinTemplate_Skeleton/Skeleton3D/AngryMouth_Object
@onready var eyes_object: BoneAttachment3D = $SwordGoblin/GoblinTemplate_Skeleton/Skeleton3D/Eyes_Object		# TODO: Need to make this work with all gobbos not just sword
@onready var death_eyes: BoneAttachment3D = $SwordGoblin/GoblinTemplate_Skeleton/Skeleton3D/DeathEyes_Object
@onready var death_mouth: BoneAttachment3D = $SwordGoblin/GoblinTemplate_Skeleton/Skeleton3D/DeathMouth_Object
@onready var neutral_eyebrows: BoneAttachment3D = $SwordGoblin/GoblinTemplate_Skeleton/Skeleton3D/NeutralEyebrows_Object


@export_category("Weapon Settings")
@export var weapon_type : WeaponType
@export var hit_count : float  ## Number of hit until thrown away

var still_alive := true
var being_swung := false
var one_hit_left := false
var active_weapon := true

func _ready() -> void:
	hurt_box.weapon_hit.connect( _reduce_hit_count )

func _reduce_hit_count() -> void:
	hit_count -= 1
	
	if still_alive:
		kill_gobbo()
	
	if hit_count == 1:
		one_hit_left = true
	elif hit_count <= 0:
		break_weapon()

func break_weapon() -> void:
	hurt_box.queue_free()
	pass # TODO: When thrown or hitcount runs out, drop from player's control and ragdoll?

func kill_gobbo() -> void:
	# Disable alive features
	angry_eyebrows.visible = false
	angry_mouth.visible = false
	eyes_object.visible = false
	# Enable dead features
	death_eyes.visible = true
	neutral_eyebrows.visible = true
	death_mouth.visible = true
	
	# is now dead
	still_alive = false
