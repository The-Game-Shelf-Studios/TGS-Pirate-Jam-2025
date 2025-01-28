class_name HurtBox extends Area3D

@export var damage : int = 0 ## Should be changed based on weapon or enemy

signal weapon_hit ## Signal emitted when player hit's an enemy with weapon

func _ready() -> void:
	area_entered.connect(area_hit)

# When hitting a hitbox, cause damage
func area_hit( area : Area3D ) -> void:
	if area is HitBox:
		area.take_damage( damage )
	if area.get_parent().is_in_group("Enemy"):
		weapon_hit.emit()
