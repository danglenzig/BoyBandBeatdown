extends Area2D
class_name ExitTrigger

@export var exit_to_scene_name: String 	= ""
@export var player_start_name: String 	= ""

@export var exit_placeholder_marker: Marker2D = null

var main: Main = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if not $"/root/Main":
		return
	main = $"/root/Main"
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name != "Player":
		return
	if not main:
		return
		
	main.change_scene.emit(exit_to_scene_name, player_start_name)
