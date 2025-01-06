extends Node2D
class_name TutorialCanvas

enum enum_called_from {START, ENVIRONMENT, ENCOUNTER, NONE}
var called_from: enum_called_from = enum_called_from.NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_skip_button_pressed():
	print_debug("This tutorial canvas was called from: ", called_from)
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
	
	var main: Main = $"/root/Main"
	match called_from:
		0:
			main.display_start_menu()
			self.call_deferred("queue_free")
		1:
			pass
		2:
			pass
		3:
			push_warning("Something weird happened")


func _on_skip_button_mouse_entered():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_hover.play()
