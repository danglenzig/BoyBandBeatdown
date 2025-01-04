extends Node
class_name ProgressionManager

const max_power = 10
const xp_to_progress: float = 1000

@export var player_start_xp: float = 10
var player_current_xp: float

var player_power = 1

@export var xp_win_against_equal = 100
@export var xp_win_against_lower = 20
@export var xp_win_against_higher = 200

@export var xp_lose_against_equal = 50
@export var xp_lose_against_lower = 10
@export var xp_lose_against_higher = 100

func _ready():
	player_current_xp = player_start_xp

func calculate_win_match_award(opponent_power)->float:
	if opponent_power == player_power:
		return xp_win_against_equal
	elif opponent_power < player_power:
		return xp_win_against_lower
	elif opponent_power > player_power:
		return xp_win_against_higher
	else:
		push_error("Something weird happened")
		return 0
	
func calculate_lose_match_award(opponent_power)->float:
	if opponent_power == player_power:
		return xp_lose_against_equal
	elif opponent_power < player_power:
		return xp_lose_against_lower
	elif opponent_power > player_power:
		return xp_lose_against_higher
	else:
		push_error("Something weird happened")
		return 0

func calculate_match_xp_award(winner:String, opponent_power: int) -> float:
	var award = 0
	match winner:
		"PLAYER":
			award = calculate_win_match_award(opponent_power)
		"OPPONENT":
			award = calculate_lose_match_award(opponent_power)
	return award
