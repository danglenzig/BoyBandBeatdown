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
var opponent_power_level: int

var rounds_to_win: int
var player_rounds_won: int 		= 0
var opponent_rounds_won: int 	= 0
var tied_rounds: int 			= 0

var player_card_in_play: Card 	= null
var opponent_card_in_play: Card = null

const decide_winner_delay 			= 1.0
const opponent_turn_delay 			= 1.0
const reveal_cards_delay 			= 1.25
const play_battle_animations_delay 	= 0.1
const display_results_delay 		= 3.5
const end_match_delay 				= 1.0


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
	var encounter_manager: NpcEncounter = get_parent()
	encounter_manager.update_sprites_rounds_won(0,0, "NONE")
	player_deck 	= deck_tools.build_deck(player_power)
	opponent_deck 	= deck_tools.build_deck(opponent_power)
	opponent_play_style = npc_play_style
	opponent_power_level = opponent_power
	# do a flashy intro cutscene here
	# for now, just wait 0.5 seconds, then proceed
	await get_tree().create_timer(0.5).timeout
	
	player_deck 	= deck_tools.deal_hand(player_deck)
	opponent_deck 	= deck_tools.deal_hand(opponent_deck)
	encounter_manager.display_cards_in_hand(player_deck.cards_in_hand)
	

	

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
		in_play_panel.self_modulate = Color(1,1,1,1)
		flip_in_play_cards()
		
func flip_in_play_cards()->void:
	
	var encounter_manager: NpcEncounter = get_parent()
	var card_holder: Node2D = encounter_manager.get_node("CanvasLayer/InPlayPanel/CardHolder")
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
			encounter_manager.update_sprites_rounds_won(player_rounds_won, opponent_rounds_won, "PLAYER")
			
		"OPPONENT":
			opponent_rounds_won += 1
			encounter_manager.update_sprites_rounds_won(player_rounds_won, opponent_rounds_won, "OPPONENT")
	
	# wait a beat then play the battle animations
	# encounter_manager.play_battle_animations() will display the results when they're fiinished
	# then it will emit encounter_events.round_over()
	
	await get_tree().create_timer(play_battle_animations_delay).timeout
	encounter_manager.play_battle_animations(result_string, reason_string, player_card_in_play.card_uuid, opponent_card_in_play.card_uuid)


func end_match(winner: String):
	var encounter_manager: NpcEncounter = get_parent()
	var progression_manager: ProgressionManager = SingletonHolder.get_node("ProgressionManager")
	var _player_power = progression_manager.player_power
	
	# award xp:
	progression_manager.player_current_xp += progression_manager.calculate_match_xp_award(winner, opponent_power_level)
	encounter_manager.end_match()

func on_round_over()->void:
	# TODO: either the match is over, or play another round
	var encounter_manager: NpcEncounter = get_parent()
	
	print_debug("TODO: either the match is over, or play another round")
	print("Player rounds won: ", player_rounds_won,"\nOpponent rounds won: ", opponent_rounds_won)
	
	if not (player_rounds_won >= rounds_to_win or opponent_rounds_won >= rounds_to_win):
		print_debug("No winner yet -- playing the next round")
		next_round()
	elif player_rounds_won >= rounds_to_win:
		
		var in_play_panel: Panel = encounter_manager.get_node("CanvasLayer/InPlayPanel")
		in_play_panel.visible = false
		
		# TODO move all this to a better place
		print_debug("Player wins this match")
		var results_panel:Panel = encounter_manager.get_node("CanvasLayer/RoundResultPanel")
		results_panel.visible = false
		encounter_manager.player_sprite.play("win")
		encounter_manager.opponent_sprite.play("lose")
		
		var sprite_shader_mat: ShaderMaterial = encounter_manager.player_sprite.material
		sprite_shader_mat.set_shader_parameter("BORDERNOISE_active", true)
		
		await get_tree().create_timer(end_match_delay).timeout
		sprite_shader_mat.set_shader_parameter("BORDERNOISE_active", false)
		# end the match
		end_match("PLAYER")
		
		
	elif opponent_rounds_won >= rounds_to_win:
		
		var in_play_panel: Panel = encounter_manager.get_node("CanvasLayer/InPlayPanel")
		in_play_panel.visible = false
		
		# TODO move all this to a better place
		print_debug("Opponent wins this match")
		var results_panel:Panel = encounter_manager.get_node("CanvasLayer/RoundResultPanel")
		results_panel.visible = false
		encounter_manager.player_sprite.play("lose")
		encounter_manager.opponent_sprite.play("win")
		
		var sprite_shader_mat: ShaderMaterial = encounter_manager.opponent_sprite.material
		sprite_shader_mat.set_shader_parameter("BORDERNOISE_active", true) 
		
		await get_tree().create_timer(end_match_delay).timeout
		sprite_shader_mat.set_shader_parameter("BORDERNOISE_active", false) 
		# end the match
		end_match("OPPONENT")
		
	else:
		push_error("Something weird happened")
		
func next_round()->void:
	player_deck = deck_tools.discard_and_draw_up(player_deck)
	opponent_deck = deck_tools.discard_and_draw_up(opponent_deck)
	var encounter_manager: NpcEncounter = get_parent()
	
	# queue free the card sprites in the in_play panel
	var in_play_card_holder: Node2D = encounter_manager.get_node("CanvasLayer/InPlayPanel/CardHolder")
	for child in in_play_card_holder.get_children():
		if child is not Marker2D:
			child.queue_free()
	
	# queue free the card sprites in the in_hand panel
	var in_hand_card_holder: Node2D = encounter_manager.get_node("CanvasLayer/HandPanel/CardHolder")
	for child in in_hand_card_holder.get_children():
		if child is not Marker2D:
			child.queue_free()
	
	# wait a beat and hide the results panel
	await get_tree().create_timer(1.0).timeout
	var round_results_panel: Panel = encounter_manager.get_node("CanvasLayer/RoundResultPanel")
	round_results_panel.visible = false
	
	# display the cards in hand panel with the new player deck
	encounter_manager.display_cards_in_hand(player_deck.cards_in_hand)
	encounter_manager.reset_encounter_sprites()
