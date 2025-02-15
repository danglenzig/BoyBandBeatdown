extends Node2D
class_name GameEnvironment

var misc_tools: MiscTools
var input_handler: InputHandler
var encounter_events: EncounterEvents
var player: Player 			= null

@export var camera_upper_y: int 	= 0
@export var camera_lower_y: int 	= 0
@export var camera_left_x: int 		= 0
@export var camera_right_x: int 	= 0

@export var encounter_scene: PackedScene
@export var environment_background_filename: String	= ""
@export var encounter_background_filename: String 	= ""

@export var is_indoor = false

#var start_marker: Marker2D  = null
var start_marker_name: String = ""
var ally_marker_name: String = ""

# child nodes
var z_scaler: ZScaler 		= null
var game_camera: GameCamera = null

var main: Main
var hud_panel: HudPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	main = $"/root/Main"
	hud_panel = main.get_hud_panel()
	misc_tools = SingletonHolder.get_node("MiscTools")
	input_handler = SingletonHolder.get_node("InputHandler")
	encounter_events = SingletonHolder.get_node("EncounterEvents")
	game_camera = $GameCamera
	game_camera.upper_y = camera_upper_y
	game_camera.lower_y = camera_lower_y
	game_camera.left_x = camera_left_x
	game_camera.right_x = camera_right_x
	setup_player()
	
	game_camera.follow_object = player
	game_camera.be_following = true
	
	encounter_events.begin_npc_encounter.connect(on_begin_encounter)
	misc_tools.toggle_nav_prompts.connect(on_toggle_nav_prompts)
	
	if has_node("ArrowPrompts"):
		get_node("ArrowPrompts").visible = false
	
func on_toggle_nav_prompts()->void:
	if not has_node("ArrowPrompts"):
		return
	get_node("ArrowPrompts").visible = not get_node("ArrowPrompts").visible
	
func setup_player() -> void:
	player = misc_tools.player_scene.instantiate()
	player.z_scaler = $ZScaler
	add_child(player)
	
	if start_marker_name == "" or not has_node(start_marker_name):
		player.global_position = $DefaultPlayerStart.global_position
	elif has_node(start_marker_name):
		var start_marker: Marker2D = get_node(start_marker_name)
		player.global_position = start_marker.global_position
	
	misc_tools.current_player = player
	
func on_begin_encounter(npc_name: String, _npc_display_name: String, npc_power: int, npc_play_style: String, npc_uuid: String) -> void:
	
	
	
	if player.current_state == "ENCOUNTER":
		return
	# hide the player and freeze movement
	player.player_state_chart.send_event("to_encounter_event")
	
	# hide the NPCs
	for npc_sprite: NpcSprite in $NpcHolder.get_children():
		npc_sprite.visible = false
		
	# hide the props
	for prop: CanvasItem in $PropHolder.get_children():
		prop.visible = false
	if has_node("AllyHolder"):
		for ally: NpcAlly in get_node("AllyHolder").get_children():
			ally.visible = false
			
	# hide the fucking arrows
	if has_node("ArrowPrompts"):
		get_node("ArrowPrompts").visible = false
	
	#	turn off the environment camera
	game_camera.enabled = false
	
	# instantiate the encounter scene
	var new_encounter: NpcEncounter = encounter_scene.instantiate()
	hud_panel.visible = false
	add_child(new_encounter)
	new_encounter.begin_encounter(npc_name,npc_power,npc_play_style,environment_background_filename,encounter_background_filename, npc_uuid)
	
func on_end_encounter(opponent_uuid: String):
	
	var opponent: NpcSprite = $NpcHolder.get_node(opponent_uuid)
	var opponent_dialog_node: NpcDialogue = opponent.npc_dialogue
	opponent_dialog_node.start_cooldown_timer()
	
	
	
	#pass
	# normalize everything we changed in on_begin_encounter()
	player.player_state_chart.send_event("to_idle_event")
	for npc_sprite: NpcSprite in $NpcHolder.get_children():
		npc_sprite.visible = true
	for prop: CanvasItem in $PropHolder.get_children():
		prop.visible = true
	if has_node("AllyHolder"):
		for ally: NpcAlly in get_node("AllyHolder").get_children():
			ally.visible = true
	if has_node("ArrowPrompts"):
		get_node("ArrowPrompts").visible = true
	game_camera.enabled = true
	hud_panel.visible = true
	"""
	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	if music_manager.current_music != music_manager.overworld_theme:
		music_manager.play_music(music_manager.overworld_theme)
	"""
	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	if is_indoor:
		music_manager.play_music("IndoorMusic")
	else:
		music_manager.play_music("OutdoorMusic")
		
	hud_panel.tween_up_xp_meter()
	
	# check if the player has leveled up
	
	# if so, do the level up stuff
	


func _on_exit_trigger_body_entered(body):
	pass # Replace with function body.
