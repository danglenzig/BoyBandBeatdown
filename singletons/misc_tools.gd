###################
## misc_tools.gd ##
###################

extends Node
class_name MiscTools

signal card_selected()
signal splash_complete()

@export var player_scene: PackedScene
var current_player: Player = null
var main: Main = null

var dialogue_active = false
var current_dialog: String = ""

const uuid_util = preload('res://uuid.gd')

func _ready():
	pass
	
	
func get_uuid() -> String:
	return uuid_util.v4()
