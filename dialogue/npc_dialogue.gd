extends Node
class_name NpcDialogue

var misc: MiscTools
var dialogue_states: DialogueStates
var encounter_events: EncounterEvents

@export var dialogue_resource_string: String 	= ""
@export var start_dialogue_tag: String 			= ""
@export var speaker_portrait_resource: String	= ""

var cooldown: float
var on_cooldown = false
var dialogue_uuid = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	misc = SingletonHolder.get_node("MiscTools")
	dialogue_states = SingletonHolder.get_node("DialogueStates")
	encounter_events = SingletonHolder.get_node("EncounterEvents")
	dialogue_uuid = misc.get_uuid()
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)
	
	var my_npc: NpcSprite = get_parent()
	cooldown = my_npc.encounter_cooldown
	
	encounter_events.review_rules_finished.connect(on_review_rules_finished)
	

func on_dialogue_ended(_resource: DialogueResource)->void:
	if dialogue_states.current_dialog != dialogue_uuid:
		return
	
	#on_cooldown = true
	
	#dialogue_states.dialogue_active = false
	dialogue_states.current_dialog = ""
	var player: Player = misc.current_player
	player.player_state_chart.send_event("to_idle_event")
	
	if dialogue_states.running_away:
		dialogue_states.running_away = false
		dialogue_states.dialogue_active = false
		start_cooldown_timer()
		return
		
	if dialogue_states.showing_help:
		dialogue_states.showing_help = false
		dialogue_states.dialogue_active = false
		
		var new_fucking_canvas_layer: CanvasLayer = CanvasLayer.new()
		var fucking_help: TutorialSequenceDeck = misc.main.deck_tutorial_scene.instantiate()
		fucking_help.current_dialogue = dialogue_uuid
		new_fucking_canvas_layer.call_deferred("add_child", fucking_help)
		new_fucking_canvas_layer.layer = 10
		fucking_help.called_from = fucking_help.enum_called_from.ENVIRONMENT
		
		var fucking_texture: TextureRect = fucking_help.get_node("TextureRect")
		fucking_texture.self_modulate = Color(1,1,1,0.9)
		
		misc.main.call_deferred("add_child", new_fucking_canvas_layer)
		print_debug(fucking_help.called_from)
		
		# show the fucking help
		# start the cooldown timer
		
		return
	
	var my_npc: NpcSprite = get_parent()
	my_npc.begin_encounter()
	
	#await get_tree().create_timer(cooldown).timeout
	#on_cooldown = false

func on_review_rules_finished(uuid: String):
	if uuid == dialogue_uuid:
		print_debug("FUCK_YOU")
		var my_npc: NpcSprite = get_parent()
		my_npc.begin_encounter()

func start_cooldown_timer()-> void:
	await get_tree().create_timer(cooldown).timeout
	on_cooldown = false

func start_dialogue():
	print_debug("Starting dialogue")
	if dialogue_states.dialogue_active:
		return
		
	dialogue_states.dialogue_active = true
	dialogue_states.current_dialog = dialogue_uuid
	var player: Player = misc.current_player
	player.player_state_chart.send_event("to_dialogue_event")
	DialogueManager.show_example_dialogue_balloon(load(dialogue_resource_string), start_dialogue_tag)
	
	#var baloon: DialogueManagerExampleBalloon = misc.main.get_node("ExampleBalloon")
	#baloon.set_speaker_portrait_texture(speaker_portrait_resource)
	
	
