extends Node2D
class_name NpcEncounter

var misc_tools: MiscTools
var encounter_events: EncounterEvents

@export var player_encounter_sprite_scene: 	PackedScene
@export var card_sprite_scene: 				PackedScene
"""
var player_sprite: 		AnimatedSprite2D
var opponent_sprite: 	AnimatedSprite2D
"""
var player_sprite: EncounterSprite
var opponent_sprite: EncounterSprite

const CARDS_IN_HAND_SCALE = Vector2(0.2, 0.2)
const CARDS_IN_PLAY_SCALE = Vector2(0.3, 0.3)

var player_in_play_card: CardSprite 	= null
var opponent_in_play_card: CardSprite 	= null


func _ready():
	misc_tools = SingletonHolder.get_node("MiscTools")
	encounter_events = SingletonHolder.get_node("EncounterEvents")
	$CanvasLayer/HandPanel.visible 				= false
	$CanvasLayer/InPlayPanel.visible 			= false
	$CanvasLayer/RoundResultPanel.visible 		= false
	
	#encounter_events.encounter_sprite_attack_anim_impact.connect(on_sprite_impact)

func setup_backgrounds(environment_bg_filename: String, encounter_bg_filename: String) -> void:
	var environment_bg_path_string: String = str("res://environments/assets/",environment_bg_filename)
	var encounter_bg_path_string: String = str("res://encounters/encounter_backgrounds/", encounter_bg_filename)
	$EnvironmentRect.texture = load(environment_bg_path_string)
	$BackgroundRect.texture = load(encounter_bg_path_string)
	
func spawn_player_sprite() -> void:
	if not player_encounter_sprite_scene:
		return
	#var new_player_sprite: AnimatedSprite2D = player_encounter_sprite_scene.instantiate()
	var new_player_sprite: EncounterSprite = player_encounter_sprite_scene.instantiate()
	new_player_sprite.global_position = $PlayerSpriteMarker.global_position
	add_child(new_player_sprite)
	player_sprite = new_player_sprite

func spawn_opponent_sprite(opponent_name) -> void:
	var scene_to_instantiate: PackedScene = null
	var resource_string = str(opponent_name,"_encounter_sprite.tscn")
	var resource_path_string = str("res://encounters/npc_sprites/",resource_string)
	var scene_holder: NpcEncounterSpriteScenes = SingletonHolder.get_node("NpcEncounterSpriteScenes")
	var npc_scenes: Array[PackedScene] = scene_holder.npc_encounter_sprite_scenes
	for npc_scene in npc_scenes:
		if npc_scene.resource_path == resource_path_string:
			scene_to_instantiate = npc_scene
			break
	if scene_to_instantiate:
		#var new_opponent_sprite: AnimatedSprite2D = scene_to_instantiate.instantiate()
		var new_opponent_sprite: EncounterSprite = scene_to_instantiate.instantiate()
		new_opponent_sprite.global_position = $OpponentSpriteMarker.global_position
		add_child(new_opponent_sprite)
		opponent_sprite = new_opponent_sprite
			
func begin_encounter(opponent_name: String, opponent_power: int, opponent_play_style: String, environment_bg_filename: String, encounter_bg_filename: String) -> void:
	
	setup_backgrounds(environment_bg_filename,encounter_bg_filename)
	spawn_player_sprite()
	spawn_opponent_sprite(opponent_name)
	
	var progression_manager: ProgressionManager = SingletonHolder.get_node("ProgressionManager")
	var player_power = progression_manager.player_power
	$MatchManager.start_match(player_power, opponent_power, opponent_play_style)
	
func display_cards_in_hand(cards: Array[Card])->void:
	
	var hand_panel: Panel 	= $CanvasLayer/HandPanel
	var card_holder: Node2D = $CanvasLayer/HandPanel/CardHolder
	var card_markers = card_holder.get_children()
	
	hand_panel.visible = true
	
	for i in range(0, card_markers.size()):
		var this_marker: Marker2D = card_markers[i]
		var this_card_data: Card = cards[i]
		var this_card_sprite: CardSprite = card_sprite_scene.instantiate()
		this_card_sprite.scale = CARDS_IN_HAND_SCALE
		this_card_sprite.position = this_marker.position
		card_holder.add_child(this_card_sprite)
		this_card_sprite.setup_card(this_card_data)
		this_card_sprite.card_face_down(false)
		await get_tree().create_timer(0.1).timeout

func play_battle_animations(result_string: String, reason_string: String, player_card_uuid: String, opponent_card_uuid: String)->void:
	
	var temp_battle_scene_duration = 4.0
	
	
	# TODO figure this shit out
		
	var player_card_sprite: CardSprite 		= null
	var opponent_card_sprite: CardSprite 	= null
	var winner_card_sprite: CardSprite 		= null
	var loser_card_sprite: CardSprite 		= null
	
	for child in $CanvasLayer/InPlayPanel/CardHolder.get_children():
		if child is not Marker2D:
			var this_card_sprite: CardSprite = child
			match this_card_sprite.card_uuid:
				player_card_uuid:
					player_card_sprite = this_card_sprite
				opponent_card_uuid:
					opponent_card_sprite = this_card_sprite
	if not player_card_sprite or not opponent_card_sprite:
		push_error("Something weird happened")
		return
	
	match result_string:
		"TIE":
			pass # play the tie animations
		"PLAYER":
			winner_card_sprite 	= player_card_sprite
			loser_card_sprite 	= opponent_card_sprite
		"OPPONENT":
			winner_card_sprite = opponent_card_sprite
			loser_card_sprite = player_card_sprite
	
	
	# temporary
	# TODO: sort this shit out
	if result_string != "TIE":
		opponent_card_sprite.active_sprite.flip_h = true
		winner_card_sprite.card_sprite_state_chart.send_event("to_attack_event")
		loser_card_sprite.card_sprite_state_chart.send_event("to_die_event")
	
	print_debug("TODO: PLAYING BATTLE ANIMATIONS")
	
	await get_tree().create_timer(temp_battle_scene_duration).timeout
	display_result_panel(result_string, reason_string)

func display_result_panel(result_string: String, reason_string: String)->void:
	var match_manager: MatchManager = $MatchManager
	match result_string:
		"PLAYER":
			result_string = "You win this round!"
		"OPPONENT":
			result_string = "You lose tnis round!"
		"TIE":
			result_string = "It's a tie!"
	
	
	$CanvasLayer/RoundResultPanel/ResultLabel.text 	= result_string
	$CanvasLayer/RoundResultPanel/ReasonLabel.text 	= reason_string
	$CanvasLayer/RoundResultPanel.visible 			= true
	
	# wait a beat then tell the match manager to continue
	await get_tree().create_timer(match_manager.display_results_delay).timeout
	encounter_events.round_over.emit()

func reset_encounter_sprites()->void:
	player_sprite.attack_signal_sent 	= false
	opponent_sprite.attack_signal_sent 	= false
	
func update_sprites_rounds_won(player_rounds_won: int, opponent_rounds_won: int, winner: String)->void:
	var player_rounds_won_string = str("Rounds Won: ",str(player_rounds_won))
	var opponent_rounds_won_string = str("Rounds Won: ", str(opponent_rounds_won))
	player_sprite.rounds_won_label.text = player_rounds_won_string
	opponent_sprite.rounds_won_label.text = opponent_rounds_won_string
	
	# play the flash effect
	match winner:
		"PLAYER":
			player_sprite.label_flash_effect.visible = true
			await  get_tree().create_timer(player_sprite.label_flash_effect_duration).timeout
			player_sprite.label_flash_effect.visible = false
		"OPPONENT":
			opponent_sprite.label_flash_effect.visible = true
			await  get_tree().create_timer(opponent_sprite.label_flash_effect_duration).timeout
			opponent_sprite.label_flash_effect.visible = false
		"NONE":
			pass
		
	
func on_player_attack_anim_finish()->void:
	pass

func on_opponent_attack_anim_finish()->void:
	pass


	
