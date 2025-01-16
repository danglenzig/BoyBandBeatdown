extends Node2D

class_name TutorialSequenceDeck

const last_step: int = 14

var current_step: int = 0

var captions_panel: 	Panel
var diagram_panel: 		Panel
var cards_panel: 		Panel
var portraits_holder: 	Node2D
var arrows_holder: 		Node2D

var countinue_button_armed: bool = true

enum enum_called_from {START, ENVIRONMENT, ENCOUNTER, NONE}
var called_from: enum_called_from = enum_called_from.NONE
var current_dialogue = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	
	captions_panel 		= $RootPanel/CaptionsPanel
	diagram_panel 		= $RootPanel/DiagramPanel
	cards_panel 		= $RootPanel/CardsPanel
	
	portraits_holder 	= $RootPanel/DiagramPanel/Portraits
	arrows_holder 		= $RootPanel/DiagramPanel/Arrows
	
	diagram_panel.visible = 	false
	captions_panel.visible = 	false
	cards_panel.visible = 		false
	
	hide_all_captions()
	highlight_portraits(["NONE"])
	highlight_arrows(["NONE"])
	await get_tree().create_timer(0.75).timeout
	step_0()

func hide_all_captions():
	for caption: Label in captions_panel.get_children():
		caption.visible = false

func show_step_caption(caption_number: int):
	hide_all_captions()
	captions_panel.visible = false
	var caption_string: String = str("Step",str(caption_number))
	var this_caption: Label = captions_panel.get_node(caption_string)
	this_caption.visible = true
	captions_panel.visible = true
	
	
func highlight_portraits(portrait_strings: Array[String]):
	for portrait: Sprite2D in portraits_holder.get_children():
		# turn off PULSE shader on portrait
		var shader_mat: ShaderMaterial = portrait.material
		shader_mat.set_shader_parameter("PULSE_active", false)
	if portrait_strings[0] == "NONE":
		print_debug("No portraits highlighted")
		return
	
	for portrait_string: String in portrait_strings:
		if not portraits_holder.has_node(portrait_string):
			push_error("Cant find portrait: ", portrait_string)
			return
		var this_portrait: Sprite2D = portraits_holder.get_node(portrait_string)
		var shader_mat: ShaderMaterial = this_portrait.material
		shader_mat.set_shader_parameter("PULSE_active", true)
	
func display_arrow(arrow_string):
	if not arrows_holder.has_node(arrow_string):
		push_error("Can's find arrow: ", arrow_string)
		return
	arrows_holder.get_node(arrow_string).visible = true
	
func highlight_arrows(arrow_strings: Array[String]):
	for arrow: Sprite2D in arrows_holder.get_children():
		# set self-modulate on this arrow to grey
		arrow.self_modulate = Color(0.5,0.5,0.5,.5)
	if arrow_strings[0] == "NONE":
		print_debug("No arrows highlighted")
		return
	for arrow_string: String in arrow_strings:
		if not arrows_holder.has_node(arrow_string):
			push_error("Can't find arrow:", arrow_string)
			return
		var this_arrow:Sprite2D = arrows_holder.get_node(arrow_string)
		this_arrow.self_modulate = Color(1.0,1.0,0.0,1.0)

func step_0():
	countinue_button_armed = false
	show_step_caption(0)
	countinue_button_armed = true
	
func step_1():
	countinue_button_armed = false
	diagram_panel.visible = true
	show_step_caption(1)
	
	countinue_button_armed = true
	
func step_2():
	countinue_button_armed = false
	highlight_portraits(["ShyOneSprite"])
	display_arrow("ShyOneToCuteOne")
	highlight_arrows(["ShyOneToCuteOne"])
	show_step_caption(2)
	
	countinue_button_armed = true
	
func step_3():
	countinue_button_armed = false
	highlight_portraits(["CuteOneSprite"])
	display_arrow("CuteOneToOlderBrother")
	highlight_arrows(["CuteOneToOlderBrother"])
	show_step_caption(3)
	
	countinue_button_armed = true

func step_4():
	countinue_button_armed = false
	highlight_portraits(["OlderBrotherSprite"])
	display_arrow("OlderBrotherToShyOne")
	highlight_arrows(["OlderBrotherToShyOne"])
	show_step_caption(4)
	
	countinue_button_armed = true
	
func step_5():
	countinue_button_armed = false
	highlight_portraits([
		"ShyOneSprite",
		"CuteOneSprite",
		"OlderBrotherSprite"
	])
	highlight_arrows([
		"ShyOneToCuteOne",
		"CuteOneToOlderBrother",
		"OlderBrotherToShyOne"
	])
	show_step_caption(5)
	
	countinue_button_armed = true
	
func step_6():
	countinue_button_armed = false
	highlight_arrows(["NONE"])
	highlight_portraits([
		"HeartthrobSprite",
		"BadBoySprite"
	])
	show_step_caption(6)
	
	countinue_button_armed = true
	
func step_7():
	countinue_button_armed = false
	highlight_portraits(["HeartthrobSprite"])
	display_arrow("HeartthrobToShyOne")
	highlight_arrows(["HeartthrobToShyOne"])
	show_step_caption(7)
	
	countinue_button_armed = true
	
func step_8():
	countinue_button_armed = false
	display_arrow("HeartthrobToCuteOne")
	highlight_arrows(["HeartthrobToCuteOne"])
	show_step_caption(8)
	
	countinue_button_armed = true

func step_9():
	countinue_button_armed = false
	display_arrow("HeartthrobToOlderBrother")
	highlight_arrows(["HeartthrobToOlderBrother"])
	show_step_caption(9)
	
	countinue_button_armed = true
	
func step_10():
	countinue_button_armed = false
	highlight_portraits([
		"ShyOneSprite",
		"CuteOneSprite",
		"OlderBrotherSprite"
	])
	display_arrow("ShyOneToBadBoy")
	display_arrow("CuteOneToBadBoy")
	display_arrow("OlderBrotherToBadBoy")
	highlight_arrows([
		"ShyOneToBadBoy",
		"CuteOneToBadBoy",
		"OlderBrotherToBadBoy"
	])
	show_step_caption(10)
	
	countinue_button_armed = true
	
func step_11():
	countinue_button_armed = false
	highlight_portraits(["BadBoySprite"])
	display_arrow("BadBoyToHeartthrob")
	highlight_arrows(["BadBoyToHeartthrob"])
	show_step_caption(11)
	
	countinue_button_armed = true
	
func step_12():
	countinue_button_armed = false
	show_step_caption(12)
	
	countinue_button_armed = true
	
func step_13():
	countinue_button_armed = false
	captions_panel.visible = false
	highlight_portraits(["NONE"])
	highlight_arrows([
		"BadBoyToHeartthrob",
		"HeartthrobToShyOne",
		"ShyOneToBadBoy",
		"HeartthrobToOlderBrother",
		"CuteOneToBadBoy",
		"HeartthrobToCuteOne",
		"OlderBrotherToBadBoy",
		"CuteOneToOlderBrother",
		"ShyOneToCuteOne",
		"OlderBrotherToShyOne",
	])
	
	await get_tree().create_timer(1.0).timeout
	diagram_panel.visible = false
	await get_tree().create_timer(0.5).timeout
	cards_panel.visible = true
	show_step_caption(13)
	
	countinue_button_armed = true
	
func step_14():
	countinue_button_armed = false
	show_step_caption(14)
	
func play_step(step_number: int):
	match step_number:
		1:
			step_1()
		2:
			step_2()
		3:
			step_3()
		4:
			step_4()
		5:
			step_5()
		6:
			step_6()
		7:
			step_7()
		8:
			step_8()
		9:
			step_9()
		10:
			step_10()
		11:
			step_11()
		12:
			step_12()
		13:
			step_13()
		14:
			step_14()
			

func _on_continue_button_pressed():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
	
	if current_step  + 1 > last_step:
		print_debug("There are no more steps")
		
		# TODO: fix this
		var continute_button: Button = $RootPanel/ContinueButton
		continute_button.visible = false
		
		if called_from == enum_called_from.ENVIRONMENT:
			var encounter_events: EncounterEvents = SingletonHolder.get_node("EncounterEvents")
			encounter_events.review_rules_finished.emit(current_dialogue)
			get_parent().call_deferred("queue_free")
			return
		
		
		
		return
		
	if not countinue_button_armed:
		return
	current_step += 1
	play_step(current_step)
	
# this functionality is now in tutorial_canvas.gd
"""
func _on_skip_button_pressed():
	
	print(called_from)
	
	var main: Main = $"/root/Main"
	match called_from:
		0:
			# was called from start menu
			main.display_start_menu()
			self.call_deferred("queue_free")
		1:
			# was called from exploration mode
			pass
		2:
			# was called from encounter mode
			pass
		3:
			# was called from none -- this should not happen
			push_warning("Something weird happened")
"""


func _on_continue_button_mouse_entered():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_hover.play()
