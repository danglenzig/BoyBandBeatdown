extends Node2D
class_name TutorialSequenceExploration

var current_step: int 	= 0
var last_step: int 		= 2

var continue_button_armed 	= true
var next_tab_button_armed 	= false
var looping_step_1 			= false

var captions_panel: Panel
var diagram_node_step_0: Node2D
var diagram_node_step_1: Node2D
var diagram_node_step_2: Node2D
var continue_button: Button
var next_tab_button: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	captions_panel 		= $RootPanel/CaptionsPanel
	diagram_node_step_0 = $RootPanel/DiagramStep0
	diagram_node_step_1 = $RootPanel/DiagramStep1
	diagram_node_step_2 = $RootPanel/DiagramStep2
	continue_button 	= $RootPanel/ContinueButton
	next_tab_button 	= $RootPanel/NextTabButton
	
	next_tab_button.visible 	= false
	captions_panel.visible 		= false
	hide_diagram_panels()
	hide_caption_labels()
	
	continue_button.visible 	= true
	
	step_0()


func play_step(step_number: int):
	match step_number:
		0:
			step_0()
		1:
			step_1()
		2:
			step_2()

func hide_diagram_panels():
	diagram_node_step_0.visible = false
	diagram_node_step_1.visible = false

func hide_caption_labels():
	for label: Label in captions_panel.get_children():
		label.visible = false

func step_0():
	hide_caption_labels()
	hide_diagram_panels()
	continue_button_armed 		= false
	captions_panel.visible 		= true
	var caption_label: Label 	= captions_panel.get_node("Step0")
	caption_label.visible 		= true
	diagram_node_step_0.visible = true
	continue_button_armed 		= true
	
func step_1():
	hide_caption_labels()
	hide_diagram_panels()
	continue_button_armed 		= false
	var caption_label: Label = captions_panel.get_node("Step1")
	caption_label.visible 		= true
	diagram_node_step_1.visible = true
	continue_button_armed 		= true
	
	
		

func step_2():
	hide_caption_labels()
	hide_diagram_panels()
	continue_button_armed 		= false
	var caption_label: Label = captions_panel.get_node("Step2")
	caption_label.visible 		= true
	diagram_node_step_2.visible = true
	continue_button.visible 	= false
	next_tab_button.visible 	= true
	next_tab_button_armed 		= true
	
func _on_continue_button_pressed():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
	
	if not continue_button_armed:
		return
	
	
	
	if current_step == 1:
		looping_step_1 = false
	
	if current_step  + 1 > last_step:
		print_debug("There are no more steps")
		
		# TODO: fix this
		var continute_button: Button = $RootPanel/ContinueButton
		continute_button.visible = false
		return
		
	if not continue_button_armed:
		return
	current_step += 1
	play_step(current_step)

func _on_next_tab_button_pressed():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
	
	if not next_tab_button_armed:
		return
	if current_step == 1:
		looping_step_1 = false
		
	if get_parent().get_parent().is_class("TabContainer"):
		var tab_container: TabContainer = get_parent().get_parent()
		tab_container.current_tab = 1

func play_hover_sound():
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_hover.play()
