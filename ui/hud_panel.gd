extends Panel

class_name HudPanel

var main_menu_button: 		Button
var level_up_panel: 		Panel
var level_up_labels: 		Node2D
var level_up_alert_node: 	LevelUpAlertNode
var current_level_label: 	Label
var next_level_label: 		Label
var xp_meter_rect:			ColorRect

var progression_manager: 	ProgressionManager

const TWEEN_DURATION = 1.0
var xp_meter_tween

# Called when the node enters the scene tree for the first time.
func _ready():
	progression_manager = SingletonHolder.get_node("ProgressionManager")
	main_menu_button = 	$MainMenuButton
	level_up_panel = 	$LevelUpPanel
	level_up_labels = 	$LevelUpLabels
	level_up_alert_node = level_up_labels.get_node("LevelUpAlertNode")
	current_level_label = level_up_labels.get_node("CurrentLevelLabel")
	next_level_label 	= level_up_labels.get_node("NextLevelLabel")
	xp_meter_rect 		= level_up_panel.get_node("ColorRect")
	
	level_up_alert_node.visible = false
	
	update_level_labels()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_level_labels():
	var current_level_text: String = str("Level\n", str(progression_manager.player_power))
	var next_level_text: String = str("Level\n", str(progression_manager.player_power + 1))
	var displayed_xp: float = progression_manager.player_current_xp / progression_manager.xp_to_progress
	
	current_level_label.text = current_level_text
	next_level_label.text = next_level_text
	xp_meter_rect.scale.x = displayed_xp

func _on_main_menu_button_pressed():
	if get_parent().get_parent().name != "Main":
		return
	var main: Main = get_parent().get_parent()
	main.display_start_menu()
	

func on_tween_finished():
	
	print(progression_manager.player_current_xp / progression_manager.xp_to_progress)
	if progression_manager.player_current_xp >= progression_manager.xp_to_progress:
		level_up_alert_node.level_up()
	else:
		update_level_labels()

func tween_up_xp_meter():
	#var current_xp_scale_x = xp_meter_rect.scale.x
	var new_xp_scale_x = progression_manager.player_current_xp / progression_manager.xp_to_progress
	new_xp_scale_x = clampf(new_xp_scale_x,0.0,1.0)
	
	var new_rect_scale = Vector2(new_xp_scale_x, xp_meter_rect.scale.y)
	xp_meter_tween = get_tree().create_tween()
	xp_meter_tween.tween_property(xp_meter_rect, "scale", new_rect_scale, TWEEN_DURATION)
	xp_meter_tween.finished.connect(func(): on_tween_finished())
