extends Node2D
class_name NpcSprite


@export var z_scaler: ZScaler = null
@export var npc_power:int = 2
@export var player_detect_radius: int = 50
@export var play_style: String = "BASIC_1"

@export var npc_name: String = "namey"
@export var npc_display_name = "Namey Nameson"
@export var auto_face_player: bool = true

@export var encounter_cooldown = 20.0

var player_inside_detect_radius = false

var misc_tools: MiscTools
var encounter_events: EncounterEvents
var dialogue_states: DialogueStates

var npc_dialogue: NpcDialogue
var npc_sprite_uuid = ""



# Called when the node enters the scene tree for the first time.
func _ready():
	misc_tools = SingletonHolder.get_node("MiscTools")
	encounter_events = SingletonHolder.get_node("EncounterEvents")
	dialogue_states = SingletonHolder.get_node("DialogueStates")
	npc_sprite_uuid = misc_tools.get_uuid()
	
	#name = str(name,"_",npc_sprite_uuid)
	name = npc_sprite_uuid
	$EncounterUI/LevelLabel.text = str("Level ", npc_power)
	$EncounterUI/StartEncounterLabel.visible 	= false
	$EncounterUI/LevelLabel.visible 			= true
	
	var my_mat: ShaderMaterial = $AnimatedSprite2D.material
	my_mat.set_shader_parameter("BORDERNOISE_active", false)
	
	npc_dialogue = $NpcDialogue
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	handle_scaling()
	handle_facing()
	handle_layering()



var ta = 0.1
var ui = 0.0
func _physics_process(_delta):
	if not dialogue_states.dialogue_active and not npc_dialogue.on_cooldown:
		handle_dialogue_detect()
	
	
	
	#handle_ui()

func handle_dialogue_detect()->void:
	var player: Player = misc_tools.current_player
	if not is_player_inside_detect_radius(player):
		return
		
	print_debug("Player_detected!")
		
	npc_dialogue.on_cooldown = true
	npc_dialogue.start_dialogue()
	


	
func is_player_inside_detect_radius(player: Player) -> bool:
	#var player: Player = misc_tools.current_player
	var player_pos: Vector2 = player.global_position
	var distance_to_player = global_position.distance_to(player_pos)
	return distance_to_player <= player_detect_radius * scale.y and player_pos.y >= global_position.y -20
	
func handle_layering():
	z_index = int(global_position.y / 10)
	
	
	
func handle_facing() -> void:
	if not auto_face_player:
		return
	var player = misc_tools.current_player
	if not player:
		return
	var player_x = player.global_position.x
	if player_x < global_position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
func handle_scaling() -> void:
	if not ZScaler:
		return
	var adjusted_scale = z_scaler.get_adjusted_scale(global_position.y)
	scale = Vector2(adjusted_scale, adjusted_scale)
	
func begin_encounter() -> void:
	#print_debug("Begin?")
	
	encounter_events.begin_npc_encounter.emit(npc_name,npc_display_name, npc_power, play_style, npc_sprite_uuid)
	

func _on_button_pressed():
	pass
	#print_debug("BEGIN")
	#encounter_events.begin_npc_encounter.emit(npc_name,npc_display_name, npc_power, play_style)


func _on_button_mouse_entered():
	pass
	#var my_mat: ShaderMaterial = $AnimatedSprite2D.material
	#my_mat.set_shader_parameter("BORDERNOISE_active", true)


func _on_button_mouse_exited():
	pass
	#var my_mat: ShaderMaterial = $AnimatedSprite2D.material
	#my_mat.set_shader_parameter("BORDERNOISE_active", false)
