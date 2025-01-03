extends Node2D

class_name TutorialSequenceDeck

const last_step: int = 13

var current_step: int = 0

var captions_panel: 	Panel
var diagram_panel: 		Panel
var portraits_holder: 	Node2D
var arrows_holder: 		Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	captions_panel = $CanvasLayer/RootPanel/CaptionsPanel
	diagram_panel = $CanvasLayer/RootPanel/DiagramPanel
	portraits_holder = $CanvasLayer/RootPanel/DiagramPanel/Portraits
	arrows_holder = $CanvasLayer/RootPanel/DiagramPanel/Arrows
	
	diagram_panel.visible = 	false
	captions_panel.visible = 	false
	
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
	show_step_caption(0)

func step_1():
	diagram_panel.visible = true
	show_step_caption(1)
	
func step_2():
	highlight_portraits(["ShyOneSprite"])
	display_arrow("ShyOneToCuteOne")
	highlight_arrows(["ShyOneToCuteOne"])
	show_step_caption(2)
	
func step_3():
	highlight_portraits(["CuteOneSprite"])
	display_arrow("CuteOneToOlderBrother")
	highlight_arrows(["CuteOneToOlderBrother"])
	show_step_caption(3)

func step_4():
	highlight_portraits(["OlderBrotherSprite"])
	display_arrow("OlderBrotherToShyOne")
	highlight_arrows(["OlderBrotherToShyOne"])
	show_step_caption(4)
	
func step_5():
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
	
func step_6():
	highlight_arrows(["NONE"])
	highlight_portraits([
		"HeartthrobSprite",
		"BadBoySprite"
	])
	show_step_caption(6)
	
func step_7():
	highlight_portraits(["HeartthrobSprite"])
	display_arrow("HeartthrobToShyOne")
	highlight_arrows(["HeartthrobToShyOne"])
	show_step_caption(7)
	
func step_8():
	display_arrow("HeartthrobToCuteOne")
	highlight_arrows(["HeartthrobToCuteOne"])
	show_step_caption(8)

func step_9():
	display_arrow("HeartthrobToOlderBrother")
	highlight_arrows(["HeartthrobToOlderBrother"])
	show_step_caption(9)
	
func step_10():
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
	
func step_11():
	highlight_portraits(["BadBoySprite"])
	display_arrow("BadBoyToHeartthrob")
	highlight_arrows(["BadBoyToHeartthrob"])
	show_step_caption(11)
	
func step_12():
	show_step_caption(12)
	
func step_13():
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
			

func _on_continue_button_pressed():
	if current_step + 1 > last_step:
		print_debug("There are no more steps")
		return
	current_step += 1
	play_step(current_step)
