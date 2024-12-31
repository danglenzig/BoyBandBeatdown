extends Node
class_name InputHandler

var move_input: Vector2 = Vector2.ZERO
signal magic_button_pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var move_x = Input.get_axis("move_left","move_right")
	var move_y = Input.get_axis("move_up","move_down")
	move_input = Vector2(move_x,move_y).normalized()
	
	if Input.is_action_just_pressed("dev_quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("dev_magic_button"):
		magic_button_pressed.emit()
