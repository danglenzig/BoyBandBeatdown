#####################
## rules_config.gd ##
#####################

extends Node
class_name RulesConfig

var rules = {
	"HEARTTHROB": 		{
		"WINS_AGAINST": {
			"CUTE_ONE" = {
				"REASON" = "Heartthrob's star power eclipses the Cute One's boyish charm."
			},
			"SHY_ONE" = {
				"REASON" = "Heartthrob's polished charisma overpowers the Shy One's meekness."
			},
			"OLDER_BROTHER" = {
				"REASON" = "Heartthrob's youthful energy outshines Older Brother's cynicism."
			},
		},
	},
	"BAD_BOY": 			{
		"WINS_AGAINST": {
			"HEARTTHROB" = {
				"REASON" = "Bad Boy's raw authenticity shatters the Hearthrob's manufactured perfection."
			},
		},
	},
	"CUTE_ONE" : 		{
		"WINS_AGAINST": {
			"OLDER_BROTHER" = {
				"REASON" = "The Cute One's irresistible cuteness melts the Older Brother's cynical resistance."
			},
			"BAD_BOY" = {
				"REASON" = "The Cute One's disarming charm deflates the Bad Boy’s bravado."
			},
		},
	},
	"OLDER_BROTHER": 	{
		"WINS_AGAINST": {
			"SHY_ONE" = {
				"REASON" = "Older Brother's discipline and experience overpower the Shy One's self-doubt."
			},
			"BAD_BOY" = {
				"REASON" = "Older Brother's steady wisdom overpowers the Bad Boy's impulsiveness."
			},
		},
	},
	"SHY_ONE": 			{
		"WINS_AGAINST": {
			"CUTE_ONE" = {
				"REASON" = "The Shy One's mysterious depth surpasses the Cute One's naiveté."
			},
			"BAD_BOY" = {
				"REASON" = "The Shy One's enigmatic presence unsettles the Bad Boy's bravado."
			},
		},
	},
}


func decide_winner(player_card: Card, opponent_card: Card)->Array[String]:
	var result_string = ""
	var reason_string = ""
	
	# decide the winner.
	# set the result string to "PLAYER", "OPPONENT", or "TIE"
	
	# a true tie
	if (player_card.suit_name == opponent_card.suit_name) and (player_card.card_rank == opponent_card.card_rank):
		result_string = "TIE"
		reason_string = "Repeat this round!"
	
	# someone wins on rank
	elif (player_card.suit_name == opponent_card.suit_name):
		if player_card.card_rank > opponent_card.card_rank:
			result_string = "PLAYER"
		else:
			result_string = "OPPONENT"
		reason_string = "Higher card rank wins!"
		
	else:
		var player_suit 	= player_card.suit_name
		var opponent_suit 	= opponent_card.suit_name
		var player_wins_against: Dictionary = rules[player_suit]["WINS_AGAINST"]
		var opponent_wins_against: Dictionary = rules[opponent_suit]["WINS_AGAINST"]
		if opponent_suit in player_wins_against.keys():
			result_string = "PLAYER"
			reason_string = rules[player_suit]["WINS_AGAINST"][opponent_suit]["REASON"]
		elif player_suit not in opponent_wins_against.keys():
			push_error("Something weird happened")
		else:
			result_string = "OPPONENT"
			reason_string = rules[opponent_suit]["WINS_AGAINST"][player_suit]["REASON"]
	
	return [result_string, reason_string]
