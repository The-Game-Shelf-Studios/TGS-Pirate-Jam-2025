extends StaticBody3D

var velocity: Vector3
var startpos 
var speed = 0.3
var Target: Vector3
var Father
signal Arrow_Struck
var isMovin = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if isMovin:
		MoveTowardTargetLocation()
	pass


func MoveTowardTargetLocation() -> void:
	var direction := Vector3(Target - startpos)
	if direction:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0 , speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	#print(velocity)
	translate(velocity.normalized())
	pass

func CheckForPlayerCollision(area: Area3D) -> void:
	if area.is_in_group("Player"):
		Father.Arrow_Struck()


	


func _on_timer_timeout() -> void:
	isMovin = true
	if startpos == null:
		startpos = position
	pass # Replace with function body.


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("hit sum")
	CheckForPlayerCollision(area)
	pass # Replace with function body.
