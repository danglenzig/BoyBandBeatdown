extends Node
class_name NpcDialogue

var misc: MiscTools

@export var dialogue_resource_string: String 	= ""
@export var start_dialogue_tag: String 			= ""
@export var speaker_portrait_resource: String	= ""

@export var cooldown = 300.0
var on_cooldown = false
var dialogue_uuid = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	misc = SingletonHolder.get_node("MiscTools")
	dialogue_uuid = misc.get_uuid()
	DialogueManager.dialogue_ended.connect(on_dialogue_ended)
	
	

func on_dialogue_ended(resource: DialogueResource)->void:
	var misc: MiscTools = SingletonHolder.get_node("MiscTools")
	if misc.current_dialog != dialogue_uuid:
		return
	
	on_cooldown = true
	
	misc.dialogue_active = false
	misc.current_dialog = ""
	var player: Player = misc.current_player
	player.player_state_chart.send_event("to_idle_event")
	
	var my_npc: NpcSprite = get_parent()
	my_npc.begin_encounter()
	
	#await get_tree().create_timer(cooldown).timeout
	#on_cooldown = false
	
	
	
	

func start_dialogue():
	print_debug("Starting dialogue")
	if on_cooldown or misc.dialogue_active:
		return
		
	misc.dialogue_active = true
	misc.current_dialog = dialogue_uuid
	var player: Player = misc.current_player
	player.player_state_chart.send_event("to_dialogue_event")
	DialogueManager.show_example_dialogue_balloon(load(dialogue_resource_string), start_dialogue_tag)
	
	var baloon: DialogueManagerExampleBalloon = misc.main.get_node("ExampleBalloon")
	baloon.set_speaker_portrait_texture(speaker_portrait_resource)
	
	
