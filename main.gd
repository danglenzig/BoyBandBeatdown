extends Node
class_name Main

#@export var temp_start_environment: PackedScene
@export var environment_scenes: Array[PackedScene]
@export var start_scene_name: String = ""

var current_environment: GameEnvironment = null

# Called when the node enters the scene tree for the first time.
func _ready():
	load_environment(start_scene_name, "StairsPlayerStart")

func load_environment(scene_name: String, start_marker_name: String):
	var resource_path_string: String = str("res://environments/",scene_name)
	var scene_to_instantiate: PackedScene = null
	for packed_scene: PackedScene in environment_scenes:
		if packed_scene.resource_path == resource_path_string:
			scene_to_instantiate = packed_scene
			break
	if scene_to_instantiate:
		if current_environment:
			current_environment.queue_free()
			current_environment = null
		var new_environment: GameEnvironment = scene_to_instantiate.instantiate()
		new_environment.start_marker_name = start_marker_name
		add_child(new_environment)
		current_environment = new_environment
		
	print_tree()
