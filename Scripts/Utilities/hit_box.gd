class_name HitBox extends Area3D

@onready var myParent = get_parent()

# When damaged emit signal with hurtbox that caused damage
func take_damage(damage: int) -> void:
	myParent.TakeDamage(damage)
	pass
