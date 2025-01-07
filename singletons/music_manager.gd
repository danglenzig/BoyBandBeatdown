extends Node
class_name MusicManager

var overworld_theme: 	AudioStreamPlayer
var encounter_theme: 	AudioStreamPlayer
var start_menu_theme: 	AudioStreamPlayer

var current_music: AudioStreamPlayer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	assign_bus()
	overworld_theme 	= $AudioStreamPlayers/overworld_theme
	encounter_theme 	= $AudioStreamPlayers/encounter_theme
	start_menu_theme 	= $AudioStreamPlayers/start_menu_theme


func assign_bus() -> void:
	for asp: AudioStreamPlayer in $AudioStreamPlayers.get_children():
		asp.bus = "Music"
		
func play_music(music: AudioStreamPlayer) -> void:
	for asp: AudioStreamPlayer in $AudioStreamPlayers.get_children():
		asp.stop()
	music.play()
	current_music = music

func stop_all_music()->void:
	for asp: AudioStreamPlayer in $AudioStreamPlayers.get_children():
		asp.stop()
	current_music = null
