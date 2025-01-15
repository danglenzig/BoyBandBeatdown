extends Area2D
class_name DialogueTriggerArea

var dialogue_states: DialogueStates

@export var dialogue_resource_string: String 	= ""
@export var start_dialogue_tag: String 			= ""
@export var speaker_portrait_resource: String 	= ""
@export var one_shot: bool 						= false
@export var cooldown: float 					= 5.0
@export var triggering_body_group:String		= "Player"

#var dialogue_active: bool 						= false
var on_cooldown: bool 							= false

var dialogue_uuid = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var misc: MiscTools = SingletonHolder.get_node("MiscTools")
	dialogue_uuid = misc.get_uuid()
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)
	
	dialogue_states = SingletonHolder.get_node("DialogueStates")

func on_dialogue_ended(_resource: DialogueResource)->void:
	#if not resource.resource_path == dialogue_resource_string:
	#	return
	
	var misc: MiscTools = SingletonHolder.get_node("MiscTools")
	if dialogue_states.current_dialog != dialogue_uuid:
		
		print_debug(dialogue_states.current_dialog)
		
		return
	on_cooldown = true
	#misc.dialogue_active = false
	#misc.current_dialog = ""
	
	#dialogue_states.dialogue_active = false
	#dialogue_states.current_dialog = ""
	
	var player: Player = misc.current_player
	player.player_state_chart.send_event("to_idle_event")
	
	if one_shot:
		call_deferred("queue_free")
	else:
		await  get_tree().create_timer(cooldown).timeout
		on_cooldown = false

func _on_body_entered(body):
	var misc: MiscTools = SingletonHolder.get_node("MiscTools")
	if not body.is_in_group(triggering_body_group) or dialogue_states.dialogue_active or on_cooldown:
		return
	match triggering_body_group:
		"Player":
			var player: Player = body
			player.player_state_chart.send_event("to_dialogue_event")
			#misc.dialogue_active = true
			#misc.current_dialog = dialogue_uuid
			
			dialogue_states.dialogue_active = true
			dialogue_states.current_dialog = dialogue_uuid
			
			DialogueManager.show_example_dialogue_balloon(load(dialogue_resource_string), start_dialogue_tag)
			#var baloon: DialogueManagerExampleBalloon = misc.main.get_node("ExampleBalloon")
			#baloon.set_speaker_portrait_texture(speaker_portrait_resource)
			"""
			if dialogue_states.current_speaker_portrait_resource != "":
				var portrait_resource: String = dialogue_states.current_speaker_portrait_resource
				dialogue_states.set_dialogue_portrait(baloon)
			"""
