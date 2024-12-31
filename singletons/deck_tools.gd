###################
## deck_tools-gd ##
###################
extends Node
class_name DeckTools

const number_of_ranks: int 	= 10
@export var level_rank_qty: int 	= 3

var suits = {
	"HEARTTHROB": 		{
		"DISPLAY_NAME": "The Heartthrob",
		# TODO "DISPLAY_FONT": ???
		"IMAGE_RESOURCE_STRINGS": {
			# TODO make and assign these
			1: "",
			2: "",
			3: "",
			4: "",
			5: "",
			6: "",
			7: "",
			8: "",
			9: "",
			10: "",
		}
	},
	"BAD_BOY": 			{
		"DISPLAY_NAME": "The Bad Boy",
		# TODO "DISPLAY_FONT": ???
		"IMAGE_RESOURCE_STRINGS": {
			# TODO make and assign these
			1: "",
			2: "",
			3: "",
			4: "",
			5: "",
			6: "",
			7: "",
			8: "",
			9: "",
			10: "",
		}
	},
	"CUTE_ONE":			{
		"DISPLAY_NAME": "The Cute One",
		# TODO "DISPLAY_FONT": ???
		"IMAGE_RESOURCE_STRINGS": {
			# TODO make and assign these
			1: "",
			2: "",
			3: "",
			4: "",
			5: "",
			6: "",
			7: "",
			8: "",
			9: "",
			10: "",
		}
	},
	"SHY_ONE":			{
		"DISPLAY_NAME": "The Shy One",
		# TODO "DISPLAY_FONT": ???
		"IMAGE_RESOURCE_STRINGS": {
			# TODO make and assign these
			1: "",
			2: "",
			3: "",
			4: "",
			5: "",
			6: "",
			7: "",
			8: "",
			9: "",
			10: "",
		}
	},
	"OLDER_BROTHER": 	{
		"DISPLAY_NAME": "The Older Brother",
		# TODO "DISPLAY_FONT": ???
		"IMAGE_RESOURCE_STRINGS": {
			# TODO make and assign these
			1: "",
			2: "",
			3: "",
			4: "",
			5: "",
			6: "",
			7: "",
			8: "",
			9: "",
			10: "",
		}
	}
}



func shuffle_deck(unshuffled_deck: Deck) -> Deck:
	var shuffled_deck_cards = unshuffled_deck.draw_pile.duplicate()
	shuffled_deck_cards.shuffle()
	unshuffled_deck.draw_pile = shuffled_deck_cards
	return unshuffled_deck
	
func deal_hand(in_deck: Deck) -> Deck:
	## check that in_deck.cards_in_hand is empty, otherwise push a warning
	if not in_deck.cards_in_hand.is_empty():
		push_warning("Cards already in hand. Cannot deal")
		return in_deck
		
	## check that there are at least 5 cards in in_deck.draw_pile.
	## otherwise, shuffle the discards back into the draw pile
	if in_deck.draw_pile.size() < 5:
		print_debug("Not enough cards in the draw pile, shuffling in discards")
		var discard_pile_size = in_deck.discard_pile.size()
		for i in range(discard_pile_size):
			in_deck.draw_pile.append(in_deck.discard_pile.pop_front())
		in_deck = shuffle_deck(in_deck)
		
	## move the top 5 cards of out_deck.draw_pile to out_deck.cards_in_hand	
	for i in range(5):
		in_deck.cards_in_hand.append(in_deck.draw_pile.pop_front())
		
	return in_deck
	
func put_card_in_play(in_deck: Deck, played_card: Card) -> Deck:
	## check that played_card is in in_deck.Cards_in_hand
	## check that in_deck.in_play == null
	## push errors if either of ^^those fail
	if not played_card in in_deck.cards_in_hand:
		push_error("Cannot play card -- card not in hand")
		return in_deck
	if in_deck.in_play != null:
		push_error("Cannot play card -- there is already a card in play")
		return in_deck
	in_deck.cards_in_hand.erase(played_card)
	in_deck.in_play = played_card
	
	# move played_card from out_deck.cards_in_hand to out_deck.in_play
	return in_deck
	
func discard_and_draw_up(in_deck: Deck) -> Deck:
	## Check that in_deck.in_play is not null
	if in_deck.in_play == null:
		push_error("Cannot discard card -- no card in play")
		return in_deck
	
	## Check that there is at least one card in in_deck.draw_pile
	## if not, shuffle the discards
	if in_deck.draw_pile.is_empty():
		print_debug("Not enough cards in the draw pile, shuffling in discards")
		var discard_pile_size = in_deck.discard_pile.size()
		for i in range(discard_pile_size):
			in_deck.draw_pile.append(in_deck.discard_pile.pop_front())
		in_deck = shuffle_deck(in_deck)
	
	## move out_deck.in_play to out_deck.discard_pile
	## move the top card of out_deck.draw_pile to out_deck.cards_in_hand
	in_deck.discard_pile.append(in_deck.in_play)
	in_deck.in_play = null
	in_deck.cards_in_hand.append(in_deck.draw_pile.pop_front())
	return in_deck

func build_deck(power: int) -> Deck:
	var new_deck: Deck = Deck.new()
	# build the deck
	
	for suit_name in suits.keys():
		for rank in range(1, number_of_ranks + 1):
			var card: Card = Card.new()
			card.make_card(suit_name, rank)
			new_deck.draw_pile.append(card)
		
		## add extra power cards
		for i in range(level_rank_qty - 1): # -1 because there's already one in the deck now
			var card: Card = Card.new()
			card.make_card(suit_name, power)
			new_deck.draw_pile.append(card)
		
	new_deck.draw_pile.shuffle()
	return new_deck

func get_card_debug_string(card: Card) -> String:
	var debug_string = "No card"
	if card:
		debug_string = str("Level ", card.card_rank," ",card.suit_name)
	return debug_string
		
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
