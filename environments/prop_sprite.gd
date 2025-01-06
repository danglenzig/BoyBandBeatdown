extends Node2D
class_name PropSprite

var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $Sprite2D
	z_index = int(global_position.y / 10)
