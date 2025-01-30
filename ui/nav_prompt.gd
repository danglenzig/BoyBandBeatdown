extends Sprite2D

@export var z_scaler: ZScaler = null
@export var scale_modifier = 1.0

const INTERVAL = .33
var ta = 0.0

var my_tween
var is_tweening = false


func _ready():
	if z_scaler:
		var my_scale = z_scaler.get_adjusted_scale(global_position.y) * scale_modifier
		scale = Vector2(my_scale,my_scale)

func _process(delta):
	if is_tweening:
		return
	
	ta += delta
	if ta < INTERVAL:
		return
	ta = 0.0
	
	is_tweening = true
	if visible:
		tween_out()
	else:
		tween_in()
	
		
func tween_in()->void:
	visible = true
	my_tween = get_tree().create_tween()
	my_tween.tween_property(self, "self_modulate", Color(1,1,0,0.75), 0.2).set_ease(Tween.EASE_IN)
	my_tween.finished.connect(func(): on_tween_finished(false))
	
func tween_out()->void:
	my_tween = get_tree().create_tween()
	my_tween.tween_property(self, "self_modulate", Color(1,1,0,0), 0.2).set_ease(Tween.EASE_OUT)
	my_tween.finished.connect(func(): on_tween_finished(true))
	
func on_tween_finished(hide_me)->void:
	if hide_me:
		visible = false
	my_tween = null
	is_tweening = false
