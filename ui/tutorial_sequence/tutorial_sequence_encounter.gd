extends Node2D
class_name TutorialSequenceEncounter


var current_step: int 	= 0
var last_step: int 		= 1

var continue_button_armed 	= true
var next_tab_button_armed 	= false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_continue_button_mouse_entered():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_hover.play()


func _on_continue_button_pressed():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
