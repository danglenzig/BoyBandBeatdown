extends Node
class_name NpcCardChooser

var play_styles = [
	# just choose a random card
	"BASIC_1",
	# choose randomly from highest ranked cards
	# "BASIC_2",
	# choose randomly from highest ranked balanced suits, else BASIC_2 behavior
	#"FAVOR_BALANCED", 
	# choose randomly from highest ranked fire suit cards, else BASIC_2 behavior
	# "FAVOR_FIRE", 
	# choose randomly from highest ranked water suit cards, else BASIC_2 behavior
	# "FAVOR_WATER",
]

func choose_card(cards: Array[Card], play_style)->String:
	var npc_play_style = "BASIC_1"
	
	if play_style not in play_styles:
		push_warning("Invalid play style, revering to BASIC_1")
	else:
		npc_play_style = play_style
	
	match  npc_play_style:
		"BASIC_1":
			var a_rando = randi_range(0,cards.size()-1)
			return cards[a_rando].card_uuid
		"BASIC_2":
			pass
		"FAVOR_BALANCED":
			pass
		"FAVOR_FIRE":
			pass
		"FAVOR_WATER":
			pass
	
	
	var chosen_card_uuid: String = ""
	
	return chosen_card_uuid
