extends Node
class_name NpcCardChooser

var play_styles = [
	"BASIC_1",
	"BASIC_2",
	"FAVOR_HEARTTHROB", 
	"FAVOR_BAD_BOY",
	"FAVOR_SHY_ONE",
	"FAVOR_OLDER_BROTHER",
	"FAVOR_CUTE_ONE",
	"ANTICIPATE_PLAYER"
]

func choose_card(cards: Array[Card], play_style)->String:
	
	var chosen_card_uuid: String = ""
	
	var npc_play_style = "BASIC_1"
	
	if play_style not in play_styles:
		push_warning("Invalid play style, revering to BASIC_1")
	else:
		npc_play_style = play_style
	
	match  npc_play_style:
		"BASIC_1":
			print_debug("Choosing a random card")
			chosen_card_uuid = basic_1(cards)
		"BASIC_2":
			# TODO: figure this out later. It is unused for now
			pass
		"FAVOR_HEARTTHROB":
			print_debug("Favoring Heartthrob")
			chosen_card_uuid = favor_heartthrob(cards)
		"FAVOR_BAD_BOY":
			print_debug("Favoring Bad Boy")
			chosen_card_uuid = favor_bad_boy(cards)
		"FAVOR_SHY_ONE":
			print_debug("Favoring Shy One")
			chosen_card_uuid = favor_shy_one(cards)
		"FAVOR_OLDER_BROTHER":
			print_debug("Favoring Older Brother")
			chosen_card_uuid = favor_older_brother(cards)
		"FAVOR_CUTE_ONE":
			print_debug("Favoring Cute One")
			chosen_card_uuid = favor_cute_one(cards)
		"ANTICIPATE_PLAYER":
			print_debug("Anticipating player behavior")
			chosen_card_uuid = anticipate_player(cards)
	return chosen_card_uuid
	
	
func anticipate_player(cards: Array[Card])->String:
	var card_uuid: String = ""
	var player_card_history = SingletonHolder.encounter_tools.player_cards_played
	if player_card_history.is_empty():
		print_debug("No player card history...chosing a random card")
		var a_rando = randi_range(0,cards.size()-1)
		card_uuid = cards[a_rando].card_uuid
	else:
		"""
		player_card_history will contain one, two, or three cards
		weight each of these according to recency
		make a prediction based on ^^that
		
		assign that value to predicted_suit
		"""
		var suit_weights = {}
		var total_weight = 0
		var weight_values = [8,7,6]
		var predicted_suit: String 	= ""
		var favored_suits: Array[String] = []
		
		for i in range(player_card_history.size()):
			var weight = weight_values[i]
			var suit = player_card_history[i]
			suit_weights[suit] = suit_weights.get(suit, 0) + weight
			total_weight += weight
		
		print_debug(suit_weights)
			
		var max_weight = -1
		for suit in suit_weights.keys():
			if suit_weights[suit] > max_weight:
				max_weight = suit_weights[suit]
				predicted_suit = suit
		
		print_debug("Predicted suit: ", predicted_suit)
		
		match predicted_suit:
			"HEARTTHROB":
				favored_suits.append("BAD_BOY")
			"BAD_BOY":
				favored_suits.append("SHY_ONE")
				favored_suits.append("CUTE_ONE")
				favored_suits.append("OLDER_BROTHER")
			"SHY_ONE":
				favored_suits.append("HEARTTHROB")
				favored_suits.append("OLDER_BROTHER")
			"OLDER_BROTHER":
				favored_suits.append("HEARTTHROB")
				favored_suits.append("CUTE_ONE")
			"CUTE_ONE":
				favored_suits.append("HEARTTHROB")
				favored_suits.append("SHY_ONE")
	
		var a_rando = randi_range(0, favored_suits.size()-1)
		var favored_suit = favored_suits[a_rando]
		
		for card:Card in cards:
			if card.suit_name == favored_suit:
				card_uuid = card.card_uuid
			else:
				a_rando = randi_range(0,cards.size()-1)
				card_uuid = cards[a_rando].card_uuid
	
	return card_uuid
	
	
func basic_1(cards: Array[Card])->String:
	var a_rando = randi_range(0,cards.size()-1)
	return cards[a_rando].card_uuid
	
func favor_heartthrob(cards: Array[Card])->String:
	for card:Card in cards:
		if card.suit_name == "HEARTTHROB":
			return card.card_uuid
			break
	var a_rando = randi_range(0,cards.size()-1)
	return cards[a_rando].card_uuid
	
func favor_bad_boy(cards: Array[Card])->String:
	for card:Card in cards:
		if card.suit_name == "BAD_BOY":
			return card.card_uuid
			break
	var a_rando = randi_range(0,cards.size()-1)
	return cards[a_rando].card_uuid
	
func favor_shy_one(cards: Array[Card])->String:
	for card:Card in cards:
		if card.suit_name == "SHY_ONE":
			return card.card_uuid
			break
	var a_rando = randi_range(0,cards.size()-1)
	return cards[a_rando].card_uuid
	
func favor_older_brother(cards: Array[Card])->String:
	for card:Card in cards:
		if card.suit_name == "OLDER_BROTHER":
			return card.card_uuid
			break
	var a_rando = randi_range(0,cards.size()-1)
	return cards[a_rando].card_uuid
	
func favor_cute_one(cards: Array[Card])->String:
	for card:Card in cards:
		if card.suit_name == "CUTE_ONE":
			return card.card_uuid
			break
	var a_rando = randi_range(0,cards.size()-1)
	return cards[a_rando].card_uuid
