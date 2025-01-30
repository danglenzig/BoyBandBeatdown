extends Node2D
class_name DanceScene

var left_sprites: Array
var right_sprites: Array
var current_left: int = -1
var current_right: int = -1
var previous_left: int = -1
var previous_right: int = -1

@export var interval: float = 1.8

signal change_it_up()

func _ready():
	left_sprites 	= $LeftDancer.get_children()
	right_sprites 	= $RightDancer.get_children()
	hide_all_sprites()
	on_interval_timeout()
	

func hide_all_sprites()->void:
	for sprite: AnimatedSprite2D in left_sprites:
		var mat: ShaderMaterial = sprite.material
		mat.set_shader_parameter("BORDERNOISE_active", false)
		mat.set_shader_parameter("FREEZE_active", false)
		sprite.visible = false
		sprite.stop()
	for sprite: AnimatedSprite2D in right_sprites:
		var mat: ShaderMaterial = sprite.material
		mat.set_shader_parameter("BORDERNOISE_active", false)
		mat.set_shader_parameter("FREEZE_active", false)
		sprite.visible = false
		sprite.stop()

func on_interval_timeout()->void:
	var new_left 	= -1
	var new_right 	= -1
	
	new_left = randi_range(0, left_sprites.size() - 1)
	while new_left == previous_left or new_left == previous_right:
		new_left = randi_range(0, left_sprites.size() - 1)
		
	new_right = randi_range(0, right_sprites.size() - 1)
	while new_right == previous_right or new_right == previous_left or new_right == new_left:
		new_right = randi_range(0, right_sprites.size() - 1)
	
	previous_left = new_left
	previous_right = new_right
	
	hide_all_sprites()
	var left_sprite: AnimatedSprite2D 	= left_sprites[new_left]
	var right_sprite: AnimatedSprite2D 	= right_sprites[new_right]
	left_sprite.frame 	= 0
	right_sprite.frame 	= 0
	left_sprite.play()
	right_sprite.play()
	
	var left_mat: ShaderMaterial = left_sprite.material
	var right_mat: ShaderMaterial = right_sprite.material
	
	right_mat.set_shader_parameter("BORDERNOISE_active", true)
	right_mat.set_shader_parameter("FREEZE_active", true)
	left_mat.set_shader_parameter("BORDERNOISE_active", true)
	left_mat.set_shader_parameter("FREEZE_active", true)
	
	change_it_up.emit()
	left_sprite.visible 	= true
	right_sprite.visible 	= true
	
	await get_tree().create_timer(0.2).timeout
	right_mat.set_shader_parameter("BORDERNOISE_active", false)
	right_mat.set_shader_parameter("FREEZE_active", false)
	left_mat.set_shader_parameter("BORDERNOISE_active", false)
	left_mat.set_shader_parameter("FREEZE_active", false)
	
	get_tree().create_timer(interval).timeout.connect(on_interval_timeout)
