extends CharacterBody2D

class_name NpcAlly

@export var move_speed 					= 300.0
@export var acceleration: float 		= 7
@export var follow_activation_distance 	= 50
var adjusted_move_speed: float

var misc			: MiscTools
var player			: Player
var npc_sprite		: AnimatedSprite2D
var npc_state_chart	: StateChart
var nav_agent		: NavigationAgent2D

var current_state: String 	= ""
var previous_state: String 	= ""
var be_following: bool 		= true

const MIN_VELOCITY: float			= 0.1
const move_input_tolerance: float 	= 0.2

var first_scaling = false

func _ready():
	misc 			= SingletonHolder.get_node("MiscTools")
	npc_sprite 		= $AnimatedSprite2D
	npc_state_chart = $StateChart
	nav_agent 		= $NavigationAgent2D
	
	set_physics_process(false)
	await get_tree().create_timer(0.1).timeout
	await get_tree().physics_frame
	set_physics_process(true)
	
	var dialogue_helper: DialogueStates = SingletonHolder.get_node("DialogueStates")
	dialogue_helper.set_nora_visibility.connect(on_set_visibility_signel)


func on_set_visibility_signel(the_bool: bool):
	var dialogue_helper: DialogueStates = SingletonHolder.get_node("DialogueStates")
	dialogue_helper.nora_introduced = true
	visible = the_bool
	
func _physics_process(delta):
	
	#print(current_state)
	
	if get_current_zscaler():
		handle_scaling(get_current_zscaler())
	handle_follow_activation()
	
	match current_state:
		"IDLE":
			pass
			
		"FOLLOW":
			
			handle_movement(delta)
			move_and_slide()
			
			#handle_follow_activation()

	
	

func handle_follow_activation()->void:
	if not misc.current_player:
		return
	var player_pos: Vector2 = misc.current_player.global_position
	
	var player_distance = global_position.distance_to(player_pos)
	
	match current_state:
		"IDLE":
			if player_distance >= follow_activation_distance * scale.length():
				npc_state_chart.send_event("to_follow_event")
		"FOLLOW":
			if player_distance < follow_activation_distance * 0.8 * scale.length():
				npc_state_chart.send_event("to_idle_event")

func handle_movement(delta)->void:
	
	if not misc.current_player:
		return
	var player_pos: Vector2 = misc.current_player.global_position
	
	if not misc.main.current_environment:
		set_physics_process(false)
	
	
	# navigate to player_pos at adjusted_move_speed
	nav_agent.target_position = player_pos	
	var move_vector: Vector2 = nav_agent.get_next_path_position() - global_position
	move_vector = move_vector.normalized()
	velocity = velocity.lerp(move_vector * adjusted_move_speed, acceleration * delta)
	
	handle_walk_animation(move_vector)
	handle_facing(move_vector)

func handle_walk_animation(move_input: Vector2)->void:
	
	if move_input.x > -move_input_tolerance and move_input.x < move_input_tolerance:
		move_input.x = 0
	if move_input.y > -move_input_tolerance and move_input.y < move_input_tolerance:
		move_input.y = 0
	
	
	if move_input.x == 0 and move_input.y !=0: # if moving straight up or down
		if move_input.y > 0:
			#print_debug("walking down")
			npc_sprite.play("walk_down")
		else:
			#print_debug("walking up")
			npc_sprite.play("walk_up")
	elif move_input.x != 0 and move_input.y == 0: # if moving straight left or right
		#print_debug("walking side")
		npc_sprite.play("walk_side")
	else:
		if move_input.y < 0:
			#print_debug("walking up/side")
			npc_sprite.play("walk_up_side")
		else:
			#print_debug("walking down/side")
			npc_sprite.play("walk_down_side")

func handle_facing(move_vector: Vector2)->void:
	if move_vector.x < 0:
		npc_sprite.flip_h = true
	else:
		npc_sprite.flip_h = false

func handle_scaling(z_scaler: ZScaler)-> void:
	
	if not first_scaling:
		first_scaling = true
	
	var _top_pos: Vector2 	= z_scaler.top_marker.global_position
	var _bottom: Vector2 	= z_scaler.bottom_marker.global_position
	var adjusted_scale = z_scaler.get_adjusted_scale(global_position.y)
	scale = Vector2(adjusted_scale, adjusted_scale)
	
	var current_anim = npc_sprite.animation
	var z_speed_adjustment = 1.0
	# if we are walking directly toward or away from the camera...
	if current_anim == "walk_up" or current_anim == "walk_down":
		z_speed_adjustment = 0.33
	# if we are walking diagonally...
	elif  current_anim == "walk_up_side" or current_anim == "walk_down_side":
		z_speed_adjustment = 0.66
	adjusted_move_speed = move_speed * adjusted_scale * z_speed_adjustment
	
	
	
	handle_layering()
	
func handle_layering()->void:
	z_index = int(global_position.y / 10)

func get_current_zscaler()->ZScaler:
	if not misc.main:
		return null
	var main: Main = misc.main
	if not main.current_environment:
		return null
	if not main.current_environment.has_node("ZScaler"):
		return null
	var current_z_scaler: ZScaler = main.current_environment.get_node("ZScaler")
	return current_z_scaler
	
	
func on_atomic_state_entered(new_state: String)->void:
	match new_state:
		"IDLE":
			npc_sprite.play("idle")
		"FOLLOW":
			pass
	
	previous_state = current_state
	current_state = new_state
