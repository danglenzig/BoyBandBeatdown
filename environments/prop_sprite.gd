extends Node2D
class_name PropSprite

var sprite: Sprite2D
@export var z_scaler: ZScaler = null
var misc: MiscTools
var main: Main

# Called when the node enters the scene tree for the first time.
func _ready():
	misc = SingletonHolder.get_node("MiscTools")
	main = misc.main
	sprite = $Sprite2D
	z_index = int(global_position.y / 10)
	
	
	if z_scaler:
		var my_scale = z_scaler.get_adjusted_scale(global_position.y)
		scale = Vector2(my_scale,my_scale)
