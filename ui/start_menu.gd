extends Node2D
class_name StartMenu

var title_tween
var start_button_tween
var about_button_tween
var quit_button_tween

var title_label: Label
var start_button_panel: Panel
var about_button_panel: Panel
var quit_button_panel: Panel

var start_button_armed = false
var about_button_armed = false
var quit_button_armed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	title_label 		= $CanvasLayer/Panel/TitleLabel
	start_button_panel 	= $CanvasLayer/Panel/StartButtonPanel
	about_button_panel 	= $CanvasLayer/Panel/AboutButtonPanel
	quit_button_panel	 = $CanvasLayer/Panel/QuitButtonPanel
	
	do_title_tween()
	await  get_tree().create_timer(0.25).timeout
	do_start_button_tween()
	await  get_tree().create_timer(0.1).timeout
	do_about_button_tween()
	await  get_tree().create_timer(0.1).timeout
	do_quit_button_tween()
	
func do_title_tween():
	title_tween = get_tree().create_tween()
	title_tween.tween_property(title_label, "position", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN)
	
func do_start_button_tween():
	start_button_tween = get_tree().create_tween()
	start_button_tween.tween_property(start_button_panel, "position", Vector2(0, start_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	start_button_tween.finished.connect(func(): on_tween_finished("START"))
func do_about_button_tween():
	about_button_tween = get_tree().create_tween()
	about_button_tween.tween_property(about_button_panel, "position", Vector2(0, about_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	about_button_tween.finished.connect(func(): on_tween_finished("ABOUT"))
func do_quit_button_tween():
	quit_button_tween = get_tree().create_tween()
	quit_button_tween.tween_property(quit_button_panel, "position", Vector2(0, quit_button_panel.position.y), 0.25).set_ease(Tween.EASE_IN)
	quit_button_tween.finished.connect(func(): on_tween_finished("QUIT"))

func on_tween_finished(button_string: String):
	match button_string:
		"START":
			start_button_armed = true
		"ABOUT":
			about_button_armed = true
		"QUIT":
			quit_button_armed = true

func on_menu_button_pressed(button_string: String):
	match button_string:
		"START":
			if not start_button_armed:
				return
			print("START!")
		"ABOUT":
			if not about_button_armed:
				return
			print("ABOUT")
		"QUIT":
			if not quit_button_armed:
				return
			get_tree().quit()
