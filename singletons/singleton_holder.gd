extends Node

var dialogue_states	: DialogueStates
var misc			: MiscTools
var help_manager	: HelpManager
var encounter_tools	: EncounterEvents

func _ready():
	dialogue_states = get_node("DialogueStates")
	misc 			= get_node("MiscTools")
	help_manager 	= get_node("HelpManager")
	encounter_tools = get_node("EncounterEvents")
	
