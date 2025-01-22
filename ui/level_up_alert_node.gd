extends Node2D
class_name LevelUpAlertNode

const DURATION = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func level_up():
	var progression_manager: ProgressionManager = SingletonHolder.get_node("ProgressionManager")
	if progression_manager.player_power >= progression_manager.max_power:
		push_warning("Already at max power")
		print_debug("ALREADY AT MAX")
		return
	
	visible = true
	await get_tree().create_timer(DURATION).timeout
	visible = false
	var hud_panel: HudPanel = get_parent().get_parent()
	
	
	
	progression_manager.player_power += 1
	progression_manager.player_current_xp = progression_manager.player_start_xp
	hud_panel.update_level_labels()
	
	if progression_manager.player_power == progression_manager.max_power:
		# TODO: Inform the player that they have reached the max level
		print_debug("YOU HAVE REACHED MAX LEVEL!!!!!!!!")
