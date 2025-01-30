extends Node3D

var GobbosRemaining = 0
var CheckForLevelCompleted: bool = false
var PlayerDied: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if CheckForLevelCompleted:
		if GobbosRemaining <= 0:
			PlayerVictory()
		else:
			if PlayerDied:
				PlayerDefeat()
	pass


func PlayerVictory() -> void:
	print("Game Won!")

func PlayerDefeat() -> void:
	print("Game Lost")

func _on_timer_timeout() -> void:
	CheckForLevelCompleted = true
	pass # Replace with function body.
