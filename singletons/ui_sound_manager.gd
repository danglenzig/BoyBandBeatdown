extends Node
class_name UiSoundManager

var card_hover: AudioStreamPlayer
var card_select: AudioStreamPlayer
var slide_sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	assign_bus()
	card_hover = $AudioStreamPlayers/CardHover
	card_select = $AudioStreamPlayers/CardSelect
	slide_sound = $AudioStreamPlayers/SlideSound


func assign_bus():
	var audiostream_players = $AudioStreamPlayers.get_children()
	for audiostream_player: AudioStreamPlayer in audiostream_players:
		audiostream_player.bus = "UISounds"
