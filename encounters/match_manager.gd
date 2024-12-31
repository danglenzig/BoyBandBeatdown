extends Node
class_name MatchManager

var deck_tools: 		DeckTools
var game_settings: 		GameSettings
var misc_tools: 		MiscTools
var encounter_events: 	EncounterEvents
var rules_config: 		RulesConfig

var player_deck: Deck 			= null
var opponent_deck: Deck 		= null
var opponent_play_style: String = ""

var rounds_to_win: int
var player_rounds_won: int 		= 0
var opponent_rounds_won: int 	= 0
var tied_rounds: int 			= 0

var player_card_in_play: Card 	= null
var opponent_card_in_play: Card = null

const decide_winner_delay = 1.0
const opponent_turn_delay 	= 1.0
const reveal_cards_delay 	= 1.25
const play_battle_animations_delay = 0.1
const display_results_delay = 2.0


func _ready():
	deck_tools 			= SingletonHolder.get_node("DeckTools")
	game_settings 		= SingletonHolder.get_node("GameSettings")
	misc_tools 			= SingletonHolder.get_node("MiscTools")
	encounter_events 	= SingletonHolder.get_node("EncounterEvents")
	rules_config 		= SingletonHolder.get_node("RulesConfig")
	
	rounds_to_win = int((game_settings.best_of_n + 1) / 2)
	
	
	encounter_events.card_selected.connect(on_card_selected)
	encounter_events.encounter_sprite_attack_anim_impact.connect(on_playerAttack_anim_impact)
	encounter_events.round_over.connect(on_round_over)

func start_match(player_power: int, opponent_power: int, npc_play_style: String) -> void:
	player_deck 	= deck_tools.build_deck(player_power)
	opponent_deck 	= deck_tools.build_deck(opponent_power)
	opponent_play_style = npc_play_style
	# do a flashy intro cutscene here
	# for now, just wait 0.5 seconds, then proceed
	await get_tree().create_timer(0.5).timeout
	
	player_deck 	= deck_tools.deal_hand(player_deck)
	opponent_deck 	= deck_tools.deal_hand(opponent_deck)
	
	var npc_encounter: NpcEncounter = get_parent()
	npc_encounter.display_cards_in_hand(player_deck.cards_in_hand)
	
func next_round()->void:
	pass
	"""
	player_deck = deck_tools.discard_and_draw_up(player_deck)
	opponent_deck = deck_tools.discard_and_draw_up(opponent_deck)
	var npc_encounter: NpcEncounter = get_parent()
	# tell the encounter manager to set shit up on screen
	"""
	

func declare_match_winner(winner: String):
	match winner:
		"PLAYER":
			pass # handle player wins
		"OPPONENT":
			pass # handle opponent wins
	
func on_card_selected(uuid_string: String):
	var card_to_play: Card = null
	for card:Card in player_deck.cards_in_hand:
		if card.card_uuid == uuid_string:
			card_to_play = card
			break
	if not card_to_play:
		push_error("Something weird happened")
	
	player_card_in_play = card_to_play
	player_deck = deck_tools.put_card_in_play(player_deck,card_to_play)
	var encounter_manager: NpcEncounter = get_parent()
	encounter_manager.player_sprite.play("attack_1")
	
func on_playerAttack_anim_impact(is_player)->void:
	
	var encounter_manager: NpcEncounter = get_parent()
	var in_hand_panel: Panel = encounter_manager.get_node("CanvasLayer").get_node("HandPanel")
	var in_play_panel: Panel = encounter_manager.get_node("CanvasLayer").get_node("InPlayPanel")
	
	if is_player:
		
		# hide the in hand panel
		in_hand_panel.visible = false
		
		# spawn a new card sprite
		var player_in_play_card_sprite: CardSprite = encounter_manager.card_sprite_scene.instantiate()
		player_in_play_card_sprite.name = "PlayerInPlayCardSprite"
		player_in_play_card_sprite.scale = encounter_manager.CARDS_IN_PLAY_SCALE
		
		# put it face down in the InPlayPanel at PlayerCardMarker.position
		# and add it to the card holder
		var player_card_marker: Marker2D = in_play_panel.get_node("CardHolder").get_node("PlayerCardMarker")
		player_in_play_card_sprite.position = player_card_marker.position
		in_play_panel.get_node("CardHolder").add_child(player_in_play_card_sprite)
		player_in_play_card_sprite.get_node("Button").queue_free()
		
		# set it up, and put it face down
		player_in_play_card_sprite.setup_card(player_card_in_play)
		player_in_play_card_sprite.card_face_down(true)
		
		# display the in play panel
		in_play_panel.visible = true
		
		# wait a beat then play the opponent attack animation
		await  get_tree().create_timer(opponent_turn_delay).timeout
		encounter_manager.opponent_sprite.play("attack_1")
		
	# what to do when the opponent attack anim finishes
	else:
		
		# opponent chooses a card
		var npc_card_chooser: NpcCardChooser = $NpcCardChooser
		var opponent_card_uuid = npc_card_chooser.choose_card(opponent_deck.cards_in_hand, opponent_play_style)
		for card: Card in opponent_deck.cards_in_hand:
			if card.card_uuid == opponent_card_uuid:
				opponent_card_in_play = card
				break
		if not opponent_card_in_play:
			push_error("Something weird happened")
		opponent_deck = deck_tools.put_card_in_play(opponent_deck, opponent_card_in_play)
		
		# put the chosen opponent card in the in play area
		# first spawn a card sprite
		var opponent_in_play_card_sprite: CardSprite = encounter_manager.card_sprite_scene.instantiate()
		opponent_in_play_card_sprite.name = "OpponentInPlayCardSprite"
		opponent_in_play_card_sprite.scale = encounter_manager.CARDS_IN_PLAY_SCALE
		
		# put it in position in the card holder
		var opponent_card_marker: Marker2D = in_play_panel.get_node("CardHolder").get_node("OpponentCardMarker")
		opponent_in_play_card_sprite.position = opponent_card_marker.position
		in_play_panel.get_node("CardHolder").add_child(opponent_in_play_card_sprite)
		opponent_in_play_card_sprite.get_node("Button").queue_free()
		
		# set it up
		opponent_in_play_card_sprite.setup_card(opponent_card_in_play)
		opponent_in_play_card_sprite.card_face_down(true)
		
		# wait for a beat then reveal the cards
		await get_tree().create_timer(reveal_cards_delay).timeout
		flip_in_play_cards()
		
func flip_in_play_cards()->void:
	
	var encounter_manager: NpcEncounter = get_parent()
	var card_holder = encounter_manager.get_node("CanvasLayer").get_node("InPlayPanel").get_node("CardHolder")
	var player_card_sprite: CardSprite 		= card_holder.get_node("PlayerInPlayCardSprite")
	var opponent_card_sprite: CardSprite 	= card_holder.get_node("OpponentInPlayCardSprite")
	player_card_sprite.card_face_down(false)
	opponent_card_sprite.card_face_down(false)
	
	# wait a beat then decide the winner
	await  get_tree().create_timer(decide_winner_delay).timeout
	decide_winner()
	
func decide_winner()->void:
	var encounter_manager: NpcEncounter = get_parent()
	var round_result:Array[String] = rules_config.decide_winner(player_card_in_play, opponent_card_in_play)
	var result_string: String = round_result[0]
	var reason_string: String = round_result[1]
	
	if result_string == "":
		print_debug("TODO, see error...")
		push_error("No round result from RulesConfig singleton")
		return
		
	match result_string:
		"TIE":
			pass
		"PLAYER":
			player_rounds_won += 1
		"OPPONENT":
			opponent_rounds_won += 1
	
	# wait a beat then play the battle animations
	# encounter_manager.play_battle_animations() will display the results when they're fiinished
	# then it will emit encounter_events.round_over()
	await get_tree().create_timer(play_battle_animations_delay).timeout
	encounter_manager.play_battle_animations(result_string, reason_string, player_card_in_play.card_uuid, opponent_card_in_play.card_uuid)

func on_round_over()->void:
	# TODO: either the match is over, or play another round
	print_debug("TODO: either the match is over, or play another round")
	"""
	
	# tell the encounter manager to put the selected card in the in play area
	npc_encounter.move_card_to_in_play(card_to_play)
	
	# some kimd of player feedback here. for now, just wait a sec...
	await get_tree().create_timer(2.0).timeout
	
	# now the opponent choses a card
	var npc_card_chooser: NpcCardChooser = $NpcCardChooser
	var opponent_card_uuid = npc_card_chooser.choose_card(opponent_deck.cards_in_hand, opponent_play_style)
	var opponent_chosen_card: Card = null
	for card: Card in opponent_deck.cards_in_hand:
		if card.card_uuid == opponent_card_uuid:
			opponent_chosen_card = card
			break
	if not opponent_chosen_card:
		push_error("Something weird happened")
	opponent_card_in_play = opponent_chosen_card
	opponent_deck = deck_tools.put_card_in_play(opponent_deck, opponent_chosen_card)
	
	# tell the encounter manager to put the chosen opponent card in the in play area
	npc_encounter.move_opponent_card_to_in_play(opponent_card_in_play)
	
	# wait for a beat then reveal the cards
	await get_tree().create_timer(1.25).timeout
	npc_encounter.flip_in_play_cards()
	
	# decide the winner, and tell the encounter manager to play the
	# appropriate animations on the in-play cards
	
	# wait a beat, then decide the winner
	await get_tree().create_timer(1.0)
	
	var round_result:Array[String] = rules_config.decide_winner(player_card_in_play, opponent_card_in_play)
	var result_string: String = round_result[0]
	var reason_string: String = round_result[1]
	
	if result_string == "":
		print_debug("TODO, see error...")
		push_error("No round result from RulesConfig singleton")
		return
	
	match result_string:
		"TIE":
			print_debug(reason_string)
			next_round() # handle tie
			return
		"PLAYER":
			print("You WIN this round!\n",reason_string)
			player_rounds_won += 1
			# tell the encounter manager to display reason_string and do the card battle animation
		"OPPONENT":
			print("You LOSE this round!\n",reason_string)
			opponent_rounds_won += 1
			# tell the encounter manager to display reason_string and do the card battle animation
	
	await get_tree().create_timer(1.0).timeout
	npc_encounter.display_result_panel(result_string, reason_string)
	
	# wait for all ^^that shit to finish, then
	if player_rounds_won >= rounds_to_win:
		declare_match_winner("PLAYER")
		return
	if opponent_rounds_won >= rounds_to_win:
		declare_match_winner("OPPONENT")
		return
	# otherwise...
	next_round()
			
	"""
	
	
