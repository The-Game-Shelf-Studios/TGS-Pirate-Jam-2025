class_name HurtBox extends Area3D

@export var damage : int = 0 ## Should be changed based on weapon or enemy

func _ready() -> void:
	pass

# When hitting a hitbox, cause damage
func DamageHitBox(target: Area3D) -> void: 
	if target is HitBox:
		target.take_damage(damage)
	pass
