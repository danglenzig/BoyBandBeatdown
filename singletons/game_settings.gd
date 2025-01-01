extends Node
class_name GameSettings

@export var best_of_n: int = 3
const min_best_of_n = 3
# Called when the node enters the scene tree for the first time.
func _ready():
	if best_of_n < min_best_of_n:
		best_of_n = min_best_of_n

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
