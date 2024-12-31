#######################
## deck_tools_tester ##
#######################

extends Node

var deck_tools: DeckTools

@export var deck_power: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("
		#####################################\n
		## EXERCISING BASIC DECK OPERATONS ##\n
		#####################################\n	
	")
	
	deck_tools = SingletonHolder.get_node("DeckTools")
	
	# get a new deck
	var a_deck = deck_tools.build_deck(deck_power)
	print("GETTING AND SHUFFLING A NEW DECK...")
	print("Deck power level: ", deck_power,"\n")
	print_deck_data(a_deck)
	
	# deal a hand
	a_deck = deck_tools.deal_hand(a_deck)
	print("DEALING A HAND...")
	print_deck_data(a_deck)
	
	# play a card
	print("PLAYING A CARD...")
	var a_rando: int = randi_range(0, a_deck.cards_in_hand.size() - 1)	
	var test_card: Card = a_deck.cards_in_hand[a_rando]
	print("---Playing card: ", get_card_debug_string(test_card),"---")
	a_deck = deck_tools.put_card_in_play(a_deck, test_card)
	print_deck_data(a_deck)
	
	# discard and draw up
	a_deck = deck_tools.discard_and_draw_up(a_deck)
	print("DISCARDING AND DRAWING UP...")
	print_deck_data(a_deck)
	

func print_deck_data(deck: Deck):
	print(str("draw pile size: ",deck.draw_pile.size()))
	print(str("in hand size: ",deck.cards_in_hand.size()))
	print("in play: ", get_card_debug_string(deck.in_play))
	print(str("discard pile size: ", deck.discard_pile.size()))
	print("Cards in hand:")
	if deck.cards_in_hand.is_empty():
		print("     None")
	else: 
		for card: Card in deck.cards_in_hand:
			print("     Level ",card.card_rank, " ",card.suit_name)
	print("\n\n")

func get_card_debug_string(card: Card) -> String:
	var debug_string = "No card"
	if card:
		debug_string = str("Level ", card.card_rank," ",card.suit_name)
	return debug_string
	
	
