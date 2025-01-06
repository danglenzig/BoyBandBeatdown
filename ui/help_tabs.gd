extends Control
class_name HelpTabs

var tab_container: TabContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	tab_container = $TabContainer
	tab_container.current_tab = 0
