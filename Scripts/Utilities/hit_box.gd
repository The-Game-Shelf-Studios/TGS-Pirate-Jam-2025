class_name HitBox extends Area3D

signal Damaged ( damage : int )

# When damaged emit signal with hurtbox that caused damage
func take_damage( hurt_box : HurtBox ) -> void:
	Damaged.emit(hurt_box)
