extends Node
class_name EncounterSoundManager

var slap_sound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	slap_sound = $AudioStreamPlayers/SlapSound

func assign_bus()->void:
	var audiostream_players = $AudioStreamPlayers.get_children()
	for audiostream_player: AudioStreamPlayer in audiostream_players:
		audiostream_player.bus = "EncounterSFX"
