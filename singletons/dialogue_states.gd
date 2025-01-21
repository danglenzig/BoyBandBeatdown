extends Node
class_name DialogueStates



var environment_00_00_seen 				= false
var current_speaker_portrait_resource 	= ""
var running_away 						= false
var showing_help 						= false

var introduced = {
	
	MARCIE 		= false,
	GRETCHEN 	= false,
	TAMMY 		= false,
	KACI 		= false,
	DANA 		= false,
	HEATHER		= false
	
}

func set_dialogue_portrait(baloon: DialogueManagerExampleBalloon):
	baloon.set_speaker_portrait_texture(current_speaker_portrait_resource)

var dialogue_active 		= false
var current_dialog: String 	= ""
