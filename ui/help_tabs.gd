extends Control
class_name HelpTabs

var tab_container: TabContainer
var deck_tutorial: TutorialSequenceDeck


# Called when the node enters the scene tree for the first time.
func _ready():
	tab_container = $TabContainer
	tab_container.current_tab = 0
	deck_tutorial = $TabContainer/Rules/TutorialSequenceDeck
	
func get_deck_tutorial()->TutorialSequenceDeck:
	return get_deck_tutorial()
