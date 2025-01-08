extends Node
class_name MusicManager

var overworld_outdoor_theme: 	AudioStreamPlayer
var overworld_indoor_theme: 	AudioStreamPlayer
var encounter_theme: 			AudioStreamPlayer
var start_menu_theme: 			AudioStreamPlayer


var cross_fader: CrossFader = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	cross_fader = $CrossFader
	
	overworld_outdoor_theme = $AudioStreamPlayers/overworld_outdoor_theme
	overworld_indoor_theme 	= $AudioStreamPlayers/overworld_indoor_theme
	encounter_theme 		= $AudioStreamPlayers/encounter_theme
	start_menu_theme 		= $AudioStreamPlayers/start_menu_theme
	
	overworld_outdoor_theme.bus = "OutdoorMusic"
	overworld_indoor_theme.bus 	= "IndoorMusic"
	encounter_theme.bus 		= "BattleMusic"
	start_menu_theme.bus 		= "StartMenuMusic"
	
	overworld_indoor_theme.play()
	overworld_outdoor_theme.play()
	encounter_theme.play()
	start_menu_theme.play()
	
	
func play_music(bus_name: String) -> void:
	cross_fader.fade_to_music(bus_name)
	
	"""
	for asp: AudioStreamPlayer in $AudioStreamPlayers.get_children():
		asp.stop()
	music.play()
	current_music = music
	"""
	
