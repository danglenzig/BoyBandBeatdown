#############
## deck.gd ##
#############

extends Node
class_name Deck

var draw_pile: 		Array[Card] 	= []
var cards_in_hand: 	Array[Card] 	= []
var in_play: 		Card 			= null
var discard_pile: 	Array[Card] 	= []
