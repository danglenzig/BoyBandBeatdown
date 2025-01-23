extends Node2D

class_name AboutCanvas


func _on_skip_button_pressed():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
	var main: Main = $"/root/Main"
	main.display_start_menu()
	self.call_deferred("queue_free")
