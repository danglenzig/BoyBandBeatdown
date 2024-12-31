extends AnimatedSprite2D
class_name EncounterSprite

@export var impact_frame_number = 0
@export var attack_animation_name: String = "attack_1"
@export var is_player: bool = false
var last_frame = 0

var encounter_events: EncounterEvents

var rounds_won_label: Label
var label_flash_effect: Sprite2D

const label_flash_effect_duration: float = 0.5

var attack_signal_sent = false

# Called when the node enters the scene tree for the first time.
func _ready():
	encounter_events = SingletonHolder.get_node("EncounterEvents")
	last_frame = sprite_frames.get_frame_count(attack_animation_name) - 1
	rounds_won_label = $RoundsWonLabel
	label_flash_effect = $FlashEffectSprite
	label_flash_effect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var current_animation = animation
	
	if current_animation == attack_animation_name:
		if frame == impact_frame_number:
			if attack_signal_sent:
				return
			attack_signal_sent = true
			encounter_events.encounter_sprite_attack_anim_impact.emit(is_player)
		if frame == last_frame:
			play("idle")
