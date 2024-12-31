#############
## card.gd ##
#############

extends Node
class_name Card
var deck_tools: DeckTools
#var misc_tools: MiscTools

var suit_name: String  				= ""
var suit_display_name: String 		= ""
var card_rank: int 					= 0
var card_uuid = ""
#var image_resource_string: String 	= ""

func _ready():
	var misc_tools = SingletonHolder.get_node("MiscTools")
		

func make_card(suit: String, rank: int) -> void:
	deck_tools = SingletonHolder.get_node("DeckTools")
	var misc_tools = SingletonHolder.get_node("MiscTools")
	
	if not suit in deck_tools.suits.keys():
		push_error("Invalid suit name: %s" % suit)
		return
	
	
	if rank < 1:
		rank = 1
	if rank > deck_tools.number_of_ranks:
		rank = deck_tools.number_of_ranks
	suit_name 				= suit
	card_rank 				= rank
	suit_display_name 		= deck_tools.suits[suit_name]["DISPLAY_NAME"]
	card_uuid 				= misc_tools.get_uuid()
	#image_resource_string 	= deck_tools.suits[suit_name]["IMAGE_RESOURCE_STRINGS"].get(card_rank, "")
