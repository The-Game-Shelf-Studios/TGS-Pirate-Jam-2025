class_name HurtBox extends Area3D

@export var damage : int = 0 ## Should be changed based on weapon or enemy

func _ready() -> void:
	area_entered.connect(area_hit)

# When hitting a hitbox, cause damage
func area_hit( area : Area3D ) -> void:
	if area is HitBox:
		area.take_damage( damage )
