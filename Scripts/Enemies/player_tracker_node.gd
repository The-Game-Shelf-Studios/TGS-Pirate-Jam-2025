extends Node

@onready var PlayerNode = get_tree().get_first_node_in_group("Player")
var PlayerRelativeDistance: float
@onready var MyParentTransform: Vector3 = get_parent().position



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	calculatePlayerDistance()




func calculatePlayerDistance() -> float:
	MyParentTransform = get_parent().position
	PlayerRelativeDistance = MyParentTransform.distance_to(PlayerNode.position)
	#print(snapped(PlayerRelativeDistance, 0.01))
	return PlayerRelativeDistance
