extends Node
class_name Main

#@export var temp_start_environment: PackedScene
@export var start_menu_scene: PackedScene
@export var environment_scenes: Array[PackedScene]
@export var tutorial_scene: PackedScene
@export var start_scene_name: String = ""


var current_environment: GameEnvironment = null
var hud_panel: HudPanel

signal change_scene()
signal start_button_pressed()
signal howto_button_pressed()

# Called when the node enters the scene tree for the first time.
func _ready():
	hud_panel = $CanvasLayer/HudPanel
	display_start_menu()
	
	change_scene.connect(load_environment)
	start_button_pressed.connect(start_new_game)
	howto_button_pressed.connect(start_tutorial_sequence)
	
	

func display_start_menu():
	hud_panel.visible = false
	var start_menu: Node2D = start_menu_scene.instantiate()
	if current_environment:
		current_environment.call_deferred("queue_free")
	current_environment = null
	call_deferred("add_child", start_menu)
	
	await get_tree().create_timer(1).timeout
	print_debug(get_children())
	


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
	call_deferred("add_child", new_environment)
	current_environment = new_environment
	hud_panel.visible = true
	
func start_tutorial_sequence(called_from: String):
	var tutorial_sequence: TutorialSequenceDeck = tutorial_scene.instantiate()
	hud_panel.visible = false
	match called_from:
		"START":
			var start_menu: StartMenu = get_node("StartMenu")
			start_menu.call_deferred("queue_free")
			tutorial_sequence.called_from = tutorial_sequence.enum_called_from.START
			call_deferred("add_child", tutorial_sequence)
		"ENVIRONMENT":
			pass
		"ENCOUNTER":
			pass
	
	
	
func start_new_game():
	print_debug("Starting new game")
	var start_menu: StartMenu = get_node("StartMenu")
	start_menu.call_deferred("queue_free")	
	load_environment(start_scene_name, "StairsPlayerStart")
	
func get_hud_panel()->HudPanel:
	return hud_panel
