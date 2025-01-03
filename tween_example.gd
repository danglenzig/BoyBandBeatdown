extends Node2D

var background_rect: TextureRect
var rect_tween 
# Called when the node enters the scene tree for the first time.
func _ready():
	rect_tween = get_tree().create_tween()
	background_rect = $CanvasLayer/TextureRect
	
	# reduce the alpha over 5 seconds to 0
	rect_tween.tween_property(background_rect, "self_modulate", Color(1,1,1,0), 5.0).set_ease(Tween.EASE_OUT)
	rect_tween.tween_callback(_on_tween_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("dev_magic_button"):
		
		# if the previous tween is still running, then kill it
		if rect_tween:
			rect_tween.kill()
			
		# now tween the alpha back up to 1 over 1 seconds
		rect_tween = get_tree().create_tween()
		rect_tween.tween_property(background_rect, "self_modulate", Color(1,1,1,1), .1).set_ease(Tween.EASE_OUT)

func _on_tween_finished():
	rect_tween.kill()
