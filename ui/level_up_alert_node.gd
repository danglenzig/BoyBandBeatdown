extends Node2D
class_name LevelUpAlertNode

const DURATION = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func level_up():
	visible = true
	await get_tree().create_timer(DURATION).timeout
	visible = false
	var hud_panel: HudPanel = get_parent().get_parent()
	
	var progression_manager: ProgressionManager = SingletonHolder.get_node("ProgressionManager")
	
	progression_manager.player_power += 1
	progression_manager.player_current_xp = progression_manager.player_start_xp
	
	hud_panel.update_level_labels()
