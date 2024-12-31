extends Node2D
class_name ZScaler

@export var top_marker: 		Marker2D
@export var bottom_marker: 		Marker2D
@export var scale_at_top: 		float = 1.0
@export var scale_at_bottom: 	float = 1.0

const MIN_SCALE = 0.01

var scale_beyond_markers 	= true
var top_y 					= 0.0
var bottom_y 				= 0.0
var area_height 			= 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if scale_at_top < MIN_SCALE:
		scale_at_top = MIN_SCALE
	if scale_at_bottom < MIN_SCALE:
		scale_at_bottom = MIN_SCALE
	
	if scale_at_top > scale_at_bottom:
		push_warning("Scale at top should be <= scale at bottom")
		scale_at_top = scale_at_bottom
	
	top_y 		= top_marker.global_position.y
	bottom_y	= bottom_marker.global_position.y
	area_height = bottom_y - top_y

func get_adjusted_scale(y_pos) -> float:
	var v_ratio = (y_pos - top_y) / area_height
	if not scale_beyond_markers:
		v_ratio = clamp(v_ratio, 0.0, 1.0)
	var adjusted_scale = scale_at_top + v_ratio * (scale_at_bottom - scale_at_top)
	if adjusted_scale < MIN_SCALE:
		adjusted_scale = MIN_SCALE
	return adjusted_scale
