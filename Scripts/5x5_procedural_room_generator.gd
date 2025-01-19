class_name ProceduralRoomGenerator_5x5 extends Node3D

#controls room spawn chance
@export var room_spawn_chance = 0.2
@export var test_material = preload("res://Assets/Materials/test_material.tres")
@export var bridge = preload("res://Assets/procedural_map_assets/bridge.res")

const ROOM_TEMPLATE = preload("res://Scenes/Environment/room_template.tscn")

var rng = RandomNumberGenerator.new()
#base grid for rooms
var grid_arr = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
#horizontal bridge array is 4 indexes with a size of 5
var bridge_arr_h = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
#vertical bridge array is 5 indexes with a size of 4
var bridge_arr_v = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var grid_room_rng = rng.randf_range(0,1)
	
	#randomizes grid
	for i in 5:
		for j in 5:
			grid_room_rng = rng.randf_range(0,1)
			grid_arr[i][j] = round_func(grid_room_rng)
			
	#prints grid for testing purposes
	for i in 5:
		print(grid_arr[i])
		
	#calls grid check function
	check_grid_nodes()
	
	#calls grid room spawner function
	create_rooms()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#custom round function that can increase or decrease the chance of a room spawning, between 0 and 1
func round_func(input_num): 

	if input_num < room_spawn_chance:
		return 0
	else:
		return 1
		

#Grid Coordniates relating to the array
#(0,0) (0,1) (0,2) (0,3) (0,4)
#(1,0) (1,1) (1,2) (1,3) (1,4)
#(2,0) (2,1) (2,2) (2,3) (2,4)
#(3,0) (3,1) (3,2) (3,3) (3,4)
#(4,0) (4,1) (4,2) (4,3) (4,4)

#gives all necessary prerequsisites for rooms and grids to be created
func check_grid_nodes():
	for i in 5:
		for j in 5:
			
			#Checks node to see if it can go south
			if (i - 1 == -1) or (grid_arr[i - 1][j] != 1):
				pass
			else:
				get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").add_to_group("North")
			
			#Checks node to see if it can go north
			if(i + 1 == 5):
				pass
			elif grid_arr[i + 1][j] != 1:
				pass
			else:
				get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").add_to_group("South")
			
			#Checks node to see if it can go east
			if(j + 1 == 5):
				pass
			elif grid_arr[i][j + 1] != 1:
				pass
			else:
				get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").add_to_group("East")
			
			#Checks node to see if it can go west
			if (j - 1 == -1) or( grid_arr[i][j - 1] != 1):
				pass
			else:
				get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").add_to_group("West")
				
				
	#determines horizontal bridges
	for i in 5:
		for j in 4:
			if (grid_arr[i][j] == 1) and (grid_arr[i][j + 1] == 1):
				bridge_arr_h[i][j] = 1
	
	#determines vertical bridges
	for i in 4:
		for j in 5:
			if (grid_arr[i][j] == 1) and (grid_arr[i + 1][j] == 1):
				bridge_arr_v[i][j] = 1
				
#function for creating rooms and bridges based on grid
#groups are retrieved in bracket form like this -> [&"West", &"East", &"North"]
#match is gdscript's version of switches
func create_rooms():
	for i in 5:
		for j in 5:
			
			#doesnt create room if not meant to
			if(grid_arr[i][j] == 0):
				continue
			
			var node_groups = get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").get_groups()
			var room_instance
			
			#testing purposes
			print("Main Grid Node/Grid(" + str(i) + "," + str(j) +") " + str(get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").get_groups()))
			
			# Enums for door directions are numbers rather than strings
			# North = 0 , East = 1, South = 2, West = 3	
			match node_groups:
				
				[&"North"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0]
					
				[&"North",&"East"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,1]
					
				[&"North",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,3]
					
				[&"North",&"South"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,2]
					
				[&"North",&"South",&"East"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,1,2]
					
				[&"North",&"South",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,2,3]
					
				[&"North",&"East",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,1,3]
					
				[&"South"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [2]
					
				[&"South",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [2,3]
					
				[&"South",&"East"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [1,2]
					
				[&"South",&"East",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [1,2,3]
					
				[&"East",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [1,3]
					
				[&"East"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [1]
					
				[&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [3]
					
				[&"North",&"South",&"East",&"West"]:
					room_instance = ROOM_TEMPLATE.instantiate()
					room_instance.doorDirections = [0,1,2,3]
				_:
					continue
					
			#adds node to grid
			if room_instance:
				get_node("Main Grid Node/Grid(" + str(i) + "," + str(j) +")").add_child(room_instance)
				
	for i in 5:
		for j in 4:
			
			var mesh_instance = MeshInstance3D.new()
			mesh_instance.material_overlay = test_material
			mesh_instance.mesh = bridge
			
			if bridge_arr_h[i][j] == 1:
				get_node("Horizontal Grid Node/HGrid(" + str(i) + "," + str(j) +")").add_child(mesh_instance)
			else:
				continue
	
	#determines vertical bridges
	for i in 4:
		for j in 5:
			var mesh_instance = MeshInstance3D.new()
			mesh_instance.material_overlay = test_material
			mesh_instance.mesh = bridge
			
			if bridge_arr_v[i][j] == 1:
				get_node("Vertical Grid Node/VGrid(" + str(i) + "," + str(j) +")").add_child(mesh_instance)
			else:
				continue
