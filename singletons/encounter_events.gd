extends Node
class_name EncounterEvents

signal begin_npc_encounter()
signal card_selected()
signal encounter_sprite_attack_anim_impact()
signal round_over()
signal review_rules_finished()

var player_cards_played: Array[String]
var pending_suit: String

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func update_card_history(played_suit: String)->void:
	
	player_cards_played.insert(0,played_suit)
	if player_cards_played.size() > 3:
		player_cards_played.pop_back()
		
	#print_debug(player_cards_played)
