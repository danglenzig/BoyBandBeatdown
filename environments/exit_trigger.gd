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
	



func _on_body_entered(body):
	if body.name != "Player":
		return
	if not main:
		return
		
	# if we are in Envoronment_01, and we are leaving trough one of thge school doors...
	if main.current_environment.name == "Environment_01" and exit_placeholder_marker:
		main.environment_01_exit_placeholder_marker_name = exit_placeholder_marker.name
	else:
		#main.environment_01_exit_placeholder_marker_name = ""
		pass
	main.change_scene.emit(exit_to_scene_name, player_start_name)
