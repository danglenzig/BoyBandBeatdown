extends Node
class_name NorHelpDialogue

@export var dialogue_resource_string: String 	= ""
var misc: MiscTools
var dialogue_states: DialogueStates
var dialogue_uuid = ""

func _ready()->void:
	misc = SingletonHolder.get_node("MiscTools")
	dialogue_states = SingletonHolder.get_node("DialogueStates")
	dialogue_uuid = misc.get_uuid()
	
func show_nora_help_dialogue(step_string: String)->void:
	if dialogue_states.dialogue_active:
		return
	dialogue_states.dialogue_active = true
	dialogue_states.current_dialog = dialogue_uuid
	DialogueManager.show_example_dialogue_balloon(load(dialogue_resource_string), step_string)
	
