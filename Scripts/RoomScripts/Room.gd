class_name Room extends Node3D

var doorways = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(): 
		if child is Doorway:
			doorways.append(child)
