extends Node2D
class_name CardSprite

var deck_tools: DeckTools
var misc_tools: MiscTools
var encounter_events: EncounterEvents

var bad_boy_sprite: 			AnimatedSprite2D
var heartthrob_sprite: 			AnimatedSprite2D
var cute_one_sprite: 			AnimatedSprite2D
var shy_one_sprite: 			AnimatedSprite2D
var older_brother_sprite: 		AnimatedSprite2D
var rank_label: 				Label
var suit_label: 				Label
var card_sprite_state_chart: 	StateChart
var card_clicker: 				Button
var card_uuid = ""

var sprites: Array[Node]

var active_sprite: AnimatedSprite2D = null

var current_state 	= ""
var previous_state 	= ""

@export var fireball_scene: PackedScene
@export var attack_impact_frame: int = 13
@export var fireball_move_x: float = 300
@export var fireball_tween_duration: float = 0.5
var fireball_tween
var fireball_launched = false

var my_pos: Vector2

const DANCE_ANIMS 	= 4
const TIE_ANIMS 	= 3

# Called when the node enters the scene tree for the first time.
func _ready():
	deck_tools = SingletonHolder.get_node("DeckTools")
	misc_tools = SingletonHolder.get_node("MiscTools")
	encounter_events = SingletonHolder.get_node("EncounterEvents")
	
	bad_boy_sprite 			= $SpriteHolder/BadBoySprite
	heartthrob_sprite 		= $SpriteHolder/HeartthrobSprite
	cute_one_sprite 		= $SpriteHolder/CuteOneSprite
	shy_one_sprite 			= $SpriteHolder/ShyOneSprite
	older_brother_sprite 	= $SpriteHolder/OlderBrotherSprite
	rank_label 				= $RankLabel
	suit_label 				= $SuitLabel
	card_sprite_state_chart = $StateChart
	card_clicker 			= $Button
	sprites 				= $SpriteHolder.get_children()
	
	for sprite:AnimatedSprite2D in sprites:
		sprite.visible = false
		
	my_pos = position
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match current_state:
		"IDLE":
			pass
		"DANCE":
			pass
		"ATTACK":
			
			# if the attacking sprite is the opponent, then flip_h will be true
			
			var last_frame = active_sprite.sprite_frames.get_frame_count("attack") - 1
			if active_sprite.frame == attack_impact_frame:
				if not fireball_launched:
					fireball_launched = true
					launch_fireball()
			if active_sprite.frame == last_frame:
				card_sprite_state_chart.send_event("to_dance_event")
		"DIE":
			pass

func launch_fireball():
	var fly_distance = fireball_move_x
	
	var fly_left = false
	if active_sprite.flip_h:
		fly_left = true
	
	var new_fireball: Sprite2D = fireball_scene.instantiate()
	
	if fly_left:
		new_fireball.rotation *= -1
		fly_distance *= -1
	
		
	var _fireball_source_marker: Marker2D = active_sprite.get_node("FireballSourceMarker")
	
	new_fireball.z_index = z_index + 1
	active_sprite.call_deferred("add_child", new_fireball)
	
	new_fireball.position = active_sprite.get_node("FireballSourceMarker").position
	if fly_left:
		new_fireball.position.x = -new_fireball.position.x
		
	var fireball_target_pos = Vector2(new_fireball.position.x + fly_distance, new_fireball.position.y)
	fireball_tween = get_tree().create_tween()
	fireball_tween.tween_property(new_fireball, "position", fireball_target_pos, fireball_tween_duration).set_ease(Tween.EASE_IN)
	fireball_tween.finished.connect(func(): on_fireball_tween_finished(new_fireball))

func on_fireball_tween_finished(new_fireball: Sprite2D):
	new_fireball.call_deferred("queue_free")

func activate_sprite(suit_name) -> void :
	if not suit_name in deck_tools.suits.keys():
		push_error("Invalid suit name")
		return
	var sprite_name = ""
	match suit_name:
		"HEARTTHROB":
			sprite_name = "HeartthrobSprite"
		"BAD_BOY":
			sprite_name = "BadBoySprite"
		"CUTE_ONE":
			sprite_name = "CuteOneSprite"
		"SHY_ONE":
			sprite_name = "ShyOneSprite"
		"OLDER_BROTHER":
			sprite_name = "OlderBrotherSprite"
	for sprite: AnimatedSprite2D in sprites:
		if sprite.name == sprite_name:
			sprite.visible = true
			active_sprite = sprite
		else:
			sprite.visible = false
			sprite.queue_free()

func setup_card(card_data: Card) -> void:
	suit_label.text = card_data.suit_display_name
	rank_label.text = str("Rank: ", card_data.card_rank)
	card_uuid = card_data.card_uuid
	activate_sprite(card_data.suit_name)

func get_random_dance_anim()->String:
	
	var a_rando: int = randi_range(1,DANCE_ANIMS)
	return str("dance",str(a_rando))
	
func  get_random_tie_anim()->String:
	var a_rando: int = randi_range(1,TIE_ANIMS)
	return str("tie",str(a_rando))

func on_atomic_state_entered(new_state) -> void:
	match new_state:
		"IDLE":
			if not active_sprite:
				return
			active_sprite.play("idle")
		"DANCE":
			if not active_sprite:
				return
			active_sprite.play(get_random_dance_anim())
		"ATTACK":
			if not active_sprite:
				return
			active_sprite.play("attack")
		"DIE":
			if not active_sprite:
				return
			active_sprite.play("die")
		"TIE":
			if not active_sprite:
				return
			active_sprite.play(get_random_tie_anim())
	previous_state = current_state
	current_state = new_state
	
	#print_debug("Entering state: ", current_state, " -- Previous state: ", previous_state)

func on_card_clicked() -> void:
	encounter_events.card_selected.emit(card_uuid)
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_select.play()
	
func card_face_down(the_bool: bool) ->void:
	if the_bool:
		$SpriteHolder.visible 	= false
		$RankLabel.visible 		= false
		$SuitLabel.visible 		= false
		$BackSide.visible 		= true
	else:
		$SpriteHolder.visible 	= true
		$RankLabel.visible 		= true
		$SuitLabel.visible 		= true
		$BackSide.visible 		= false




func _on_button_mouse_entered():
	position = Vector2(my_pos.x, my_pos.y - 30)
	var ui_sounds: UiSoundManager = SingletonHolder.get_node("UiSoundManager")
	ui_sounds.card_hover.play()


func _on_button_mouse_exited():
	position = my_pos
