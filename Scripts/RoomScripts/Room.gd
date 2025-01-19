class_name Room extends Node3D

var doorDirections = []

var doorways = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(): 
		if child is Doorway:
			doorways.append(child)
	
	setupRoom()


# Enums for door directions are numbers rather than strings
# North = 0 , East = 1, South = 2, West = 3 
func setupRoom() -> void:
	for dir in doorDirections:
		print_debug(str(doorways.size()))
		for d in doorways:
			#print_debug(var_to_str(d.myDirection))
			if dir == d.myDirection:
				d.setupDoor()
			pass
	pass
