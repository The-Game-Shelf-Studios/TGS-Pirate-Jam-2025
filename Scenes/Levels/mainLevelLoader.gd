extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Environment/gamejam_main_level.tscn")
	pass # Replace with function body.
