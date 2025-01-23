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
var dance_scene: 		DanceScene

var start_button_armed = 	false
var howto_button_armed = 	false
var about_button_armed = 	false
var quit_button_armed = 	false

var main: Main = null

var environment_textures = [
	preload("res://environments/assets/env_00.png"),
	preload("res://environments/assets/env_01.png"),
	preload("res://environments/assets/env_03_alt.png"),
	preload("res://environments/assets/env_06.png"),
	preload("res://environments/assets/env_05.png"),
]
var current_background_texture_index = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	
	if get_parent().name == "Main":
		main = get_parent()
	
	title_label 		= $CanvasLayer/Panel/TitleLabel
	start_button_panel 	= $CanvasLayer/Panel/StartButtonPanel
	howto_button_panel 	= $CanvasLayer/Panel/HowToButtonPanel
	about_button_panel 	= $CanvasLayer/Panel/AboutButtonPanel
	quit_button_panel	= $CanvasLayer/Panel/QuitButtonPanel
	dance_scene 		= $CanvasLayer/Panel/DanceScene
	dance_scene.change_it_up.connect(on_change_it_up)

	var music_manager: MusicManager = SingletonHolder.get_node("MusicManager")
	music_manager.play_music("StartMenuMusic")
	
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

func on_change_it_up()->void:
	var background_sprite: Sprite2D = $CanvasLayer/Panel/BackgroundSprite
	current_background_texture_index += 1
	current_background_texture_index = current_background_texture_index % environment_textures.size()
	background_sprite.texture = environment_textures[current_background_texture_index]

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
	
func show_about_from_start_menu()->void:
	if not main:
		return
	main.about_button_pressed.emit()
	
	
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
			show_about_from_start_menu()
			
		"QUIT":
			if not quit_button_armed:
				return
			ui_sounds.card_select.play()
			get_tree().quit()
