extends Node2D

class_name TutorialSequence

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
	highlight_portrait("NONE")
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

func highlight_portrait(portrait_string):
	for portrait: Sprite2D in portraits_holder.get_children():
		print_debug("Disabling portrait highlight: ", portrait.name)
		# turn off PULSE shader on portrait
	if portrait_string == "NONE":
		print_debug("No portraits highlighted")
		return
	if not portraits_holder.has_node(portrait_string):
		push_error("Cant find portrait: ", portrait_string)
		return
	var highlighted_portrait: Sprite2D = portraits_holder.get_node(portrait_string)
	print_debug("Highlighing portrait: ", highlighted_portrait.name)
	# turn on PULSE shader on highlighted portrait
	
func display_arrow(arrow_string):
	if not arrows_holder.has_node(arrow_string):
		push_error("Can's find arrow: ", arrow_string)
		return
	arrows_holder.get_node(arrow_string).visible = true
	
func highlight_arrows(arrow_strings: Array[String]):
	
	for arrow: Sprite2D in arrows_holder.get_children():
		print_debug("Unhighlighting arrow: ", arrow.name)
		# set self-modulate on this arrow to grey
	if arrow_strings[0] == "NONE":
		print_debug("No arrows highlighted")
		return
	
	for i in range(0, arrow_strings.size()-1):
		var this_string: String = arrow_strings[1]
		if not arrows_holder.has_node(this_string):
			push_error("Cant find arrow: ", this_string)
			return
		var this_arrow: Sprite2D = arrows_holder.get_node(this_string)
		print_debug("Highlighting arrow: ", this_arrow.name)
		# set self-modulate on this_arrow yo yellow
		
	
	

func step_0():
	show_step_caption(0)

func step_1():
	diagram_panel.visible = true
	show_step_caption(1)
	
func step_2():
	highlight_portrait("ShyOneSprite")
	display_arrow("ShyOneToCuteOne")
	highlight_arrows(["ShyOneToCuteOne"])
	show_step_caption(2)
	
	
func step_3():
	pass

func step_4():
	pass
	
func step_5():
	pass
	
func step_6():
	pass
	
func step_7():
	pass
	
func step_8():
	pass

func step_9():
	pass
	
func step_10():
	pass
	
func step_11():
	pass

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
			

func _on_continue_button_pressed():
	current_step += 1
	play_step(current_step)
