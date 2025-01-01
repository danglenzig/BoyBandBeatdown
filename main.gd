extends Node
class_name Main

#@export var temp_start_environment: PackedScene
@export var environment_scenes: Array[PackedScene]
@export var start_scene_name: String = ""

var current_environment: GameEnvironment = null

signal change_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	load_environment(start_scene_name, "StairsPlayerStart")
	#change_scene.connect(fucking_test)
	change_scene.connect(load_environment)

func fucking_test(test_1: String, test_2: String):
	print(test_1," -- ", test_2)

func load_environment(scene_name: String, start_marker_name: String):
	var resource_path_string: String = str("res://environments/",scene_name)
	var scene_to_instantiate: PackedScene = null
	for packed_scene: PackedScene in environment_scenes:
		if packed_scene.resource_path == resource_path_string:
			scene_to_instantiate = packed_scene
			break
			
	if not scene_to_instantiate:
		push_warning("Can't find that scene")
		return
		
		
	if current_environment:
		current_environment.call_deferred("queue_free")
		
	var new_environment: GameEnvironment = scene_to_instantiate.instantiate()
	new_environment.start_marker_name = start_marker_name
	# add_child(new_environment)
	call_deferred("add_child", new_environment)
	current_environment = new_environment
		
	#print_tree()
