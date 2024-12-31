extends Camera2D
class_name GameCamera

var follow_object: Node2D 	= null
var be_following: bool 		= false

var upper_y: int 	= 0
var lower_y: int 	= 0
var right_x: int 	= 0
var left_x: int 	= 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if follow_object and be_following:
		var follow_x = follow_object.global_position.x
		var follow_y = follow_object.global_position.y
		
		if upper_y != 0 and lower_y != 0:
			follow_y = clamp(follow_y, upper_y, lower_y)
		if left_x != 0 and right_x != 0:
			follow_x = clamp(follow_x, left_x, right_x)
	
		var follow_pos = Vector2(follow_x, follow_y)
		global_position = follow_pos
