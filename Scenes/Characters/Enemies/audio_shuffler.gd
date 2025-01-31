extends Node

#here we are collecting the sounds for gobbos on the floor to make
#we want to collect the sounds for swinging the sword and for getting hit here, the rest are going on their own shuffler for the item in hand



var swing1 = "res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 1.mp3"
var swing2 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 2.mp3"
var swing3 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 3.mp3"
var swing4 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 4.mp3"
var swing5 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 5.mp3"
var swing6 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 6.mp3"
var swing7 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 7-2.mp3"
var swing8 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 8.mp3"
var swing9 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 9.mp3"
var swing10 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 10.mp3"
var swing11 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 11.mp3"
var swing12 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 12.mp3"
var swing13 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 13.mp3"
var swing14 ="res://Assets/sounds/Voice Lines/Sword Goblin/Hitting/Hitting 14.mp3"

var hit1 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 1.mp3"
var hit2 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 2.mp3"
var hit3 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 3.mp3"
var hit4 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 4.mp3"
var hit5 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 5.mp3"
var hit6 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 6.mp3"
var hit7 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 7.mp3"
var hit8 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 8.mp3"
var hit9 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 9.mp3"
var hit10 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 10.mp3"
var hit11 ="res://Assets/sounds/Voice Lines/Sword Goblin/Being Hit/Being Hit 11.mp3"
var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func GiveRandomSwingClip() -> void:
	var x = rng.randi_range(0, 13)
	match x:
		0:

	pass

func GiveRandomHitClip() -> void:
	pass
