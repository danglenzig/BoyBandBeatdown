###################
## misc_tools.gd ##
###################

extends Node
class_name MiscTools

signal card_selected()

@export var player_scene: PackedScene
var current_player: Player = null

const uuid_util = preload('res://uuid.gd')



func get_uuid() -> String:
	return uuid_util.v4()
