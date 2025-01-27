extends Node
class_name Main

var misc_tools: MiscTools

#@export var temp_start_environment: PackedScene
@export var start_menu_scene: PackedScene
@export var environment_scenes: Array[PackedScene]
#@export var tutorial_scene: PackedScene
@export var tutorial_canvas_scene: PackedScene
@export var about_canvas_scene: PackedScene
@export var deck_tutorial_scene: PackedScene
@export var splash_screen_scene: PackedScene
var splash_screen: Control = null

@export var start_scene_name: String = ""
@export var start_with_splash: bool = false


var current_environment: GameEnvironment = null
var hud_panel: HudPanel

signal change_scene()
signal start_button_pressed()
signal howto_button_pressed()
signal about_button_pressed()

var environment_01_exit_placeholder_marker_name = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	
	misc_tools = SingletonHolder.get_node("MiscTools")
	misc_tools.main = self
	misc_tools.splash_complete.connect(on_splash_complete)
	
	
	hud_panel = $CanvasLayer/HudPanel
	#display_start_menu()
	
	change_scene.connect(load_environment)
	start_button_pressed.connect(start_new_game)
	howto_button_pressed.connect(start_tutorial_sequence)
	about_button_pressed.connect(display_about)
	
	if start_with_splash:
		splash_screen = splash_screen_scene.instantiate()
		$CanvasLayer.call_deferred("add_child", splash_screen)
	else:
		display_start_menu()
		
	

func on_splash_complete():
	splash_screen.call_deferred("queue_free")
	display_start_menu()

func display_start_menu():
	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	if not music_manager.music_playing:
		music_manager.start_music()
		
	
	hud_panel.visible = false
	var start_menu: Node2D = start_menu_scene.instantiate()
	if current_environment:
		current_environment.call_deferred("queue_free")
	current_environment = null
	call_deferred("add_child", start_menu)
	
	await get_tree().create_timer(1).timeout
	#print_debug(get_children())
	


func fucking_test(test_1: String, test_2: String):
	print(test_1," -- ", test_2)

func load_environment(scene_name: String, start_marker_name: String, ally_start_name: String = ""):
	
	
	if ally_start_name != "":
		print_debug(ally_start_name)
	
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
	
	# deal with the Environment_01 situation (multiple exits got to the same place)
	if new_environment.name == "Environment_01":
		
		#print_debug(environment_01_exit_placeholder_marker_name)
		
		if environment_01_exit_placeholder_marker_name != "":
			new_environment.start_marker_name = environment_01_exit_placeholder_marker_name
			environment_01_exit_placeholder_marker_name = ""
		else:
			new_environment.start_marker_name = start_marker_name
	else:
		new_environment.start_marker_name = start_marker_name
		
	new_environment.ally_marker_name = ally_start_name
	
		
	call_deferred("add_child", new_environment)
	current_environment = new_environment
	hud_panel.visible = true
	"""
	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	if music_manager.current_music != music_manager.overworld_theme:
		music_manager.play_music(music_manager.overworld_theme)
	"""
	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	if new_environment.is_indoor:
		music_manager.play_music("IndoorMusic")
	else :
		music_manager.play_music("OutdoorMusic")
	
func start_tutorial_sequence(called_from: String):
	#var tutorial_sequence: TutorialSequenceDeck = tutorial_scene.instantiate()
	
	#var tutorial_canvas: TutorialCanvas = tutorial_canvas_scene.instantiate()
	#hud_panel.visible = false
	match called_from:
		"START":
			# old:
			"""
			var start_menu: StartMenu = get_node("StartMenu")
			start_menu.call_deferred("queue_free")
			tutorial_sequence.called_from = tutorial_sequence.enum_called_from.START
			call_deferred("add_child", tutorial_sequence)
			"""
			
			var tutorial_canvas: TutorialCanvas = tutorial_canvas_scene.instantiate()
			hud_panel.visible = false
			
			var start_menu: StartMenu = get_node("StartMenu")
			start_menu.call_deferred("queue_free")
			tutorial_canvas.called_from = tutorial_canvas.enum_called_from.START
			call_deferred("add_child", tutorial_canvas)
			
			
			
		"ENVIRONMENT":
			
			pass
			
		"ENVIRONMENT":
			pass
		"ENCOUNTER":
			pass
	
func display_about()->void:
	var about_canvas: AboutCanvas = about_canvas_scene.instantiate()
	hud_panel.visible = false
	var start_menu: StartMenu = get_node("StartMenu")
	start_menu.call_deferred("queue_free")
	call_deferred("add_child", about_canvas)
	
	
func start_new_game():
	#print_debug("Starting new game")
	var start_menu: StartMenu = get_node("StartMenu")
	start_menu.call_deferred("queue_free")	
	load_environment(start_scene_name, "DefaultPlayerStart")
	
func get_hud_panel()->HudPanel:
	return hud_panel
