extends Node2D
class_name StartMenu

var title_tween
var start_button_tween
var howto_button_tween
var about_button_tween
var quit_button_tween

var title_label: 		Label
var start_button_panel: Panel
var howto_button_panel: Panel
var about_button_panel: Panel
var quit_button_panel: 	Panel

var start_button_armed = 	false
var howto_button_armed = 	false
var about_button_armed = 	false
var quit_button_armed = 	false

var main: Main = null



# Called when the node enters the scene tree for the first time.
func _ready():
	
	if get_parent().name == "Main":
		main = get_parent()
	
	title_label 		= $CanvasLayer/Panel/TitleLabel
	start_button_panel 	= $CanvasLayer/Panel/StartButtonPanel
	howto_button_panel 	= $CanvasLayer/Panel/HowToButtonPanel
	about_button_panel 	= $CanvasLayer/Panel/AboutButtonPanel
	quit_button_panel	= $CanvasLayer/Panel/QuitButtonPanel
	
	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	if music_manager.current_music != music_manager.start_menu_theme:
		music_manager.play_music(music_manager.start_menu_theme)
	
	do_title_tween()
	await  get_tree().create_timer(0.25).timeout
	do_start_button_tween()
	await  get_tree().create_timer(0.1).timeout
	do_howto_button_tween()
	await  get_tree().create_timer(0.1).timeout
	do_about_button_tween()
	await  get_tree().create_timer(0.1).timeout
	do_about_button_tween()
	await  get_tree().create_timer(0.1).timeout
	do_quit_button_tween()
	
func do_title_tween():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.slide_sound.play()
	title_tween = get_tree().create_tween()
	title_tween.tween_property(title_label, "position", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN)
	
func do_start_button_tween():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.slide_sound.play()
	start_button_tween = get_tree().create_tween()
	start_button_tween.tween_property(start_button_panel, "position", Vector2(0, start_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	start_button_tween.finished.connect(func(): on_tween_finished("START"))
	
func do_howto_button_tween():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.slide_sound.play()
	howto_button_tween = get_tree().create_tween()
	howto_button_tween.tween_property(howto_button_panel, "position", Vector2(0, howto_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	howto_button_tween.finished.connect(func(): on_tween_finished("HOWTO"))
	
func do_about_button_tween():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.slide_sound.play()
	about_button_tween = get_tree().create_tween()
	about_button_tween.tween_property(about_button_panel, "position", Vector2(0, about_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	about_button_tween.finished.connect(func(): on_tween_finished("ABOUT"))
func do_quit_button_tween():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.slide_sound.play()
	quit_button_tween = get_tree().create_tween()
	quit_button_tween.tween_property(quit_button_panel, "position", Vector2(0, quit_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	quit_button_tween.finished.connect(func(): on_tween_finished("QUIT"))

func on_tween_finished(button_string: String):
	match button_string:
		"START":
			start_button_armed 	= true
		"HOWTO":
			howto_button_armed 	= true
		"ABOUT":
			about_button_armed 	= true
		"QUIT":
			quit_button_armed 	= true


func start_new_game():
	if not main:
		return
	main.start_button_pressed.emit()
	
func play_tutorial_from_start_menu():
	if not main:
		return
	main.howto_button_pressed.emit("START")
	
func play_card_hover_sound():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_hover.play()

func on_menu_button_pressed(button_string: String):
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	match button_string:
		"START":
			if not start_button_armed:
				return
			ui_sounds.card_select.play()
			start_new_game()
		"HOWTO":
			if not howto_button_armed:
				return
			ui_sounds.card_select.play()
			play_tutorial_from_start_menu()
		"ABOUT":
			if not about_button_armed:
				return
			ui_sounds.card_select.play()
			print("ABOUT")
		"QUIT":
			if not quit_button_armed:
				return
			ui_sounds.card_select.play()
			get_tree().quit()
