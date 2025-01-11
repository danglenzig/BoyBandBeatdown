extends CharacterBody2D
class_name Player

@export var move_speed: float 	= 300.0
@export var use_z_scaling: bool = true
@export var footstep_frames: Array[int]

var adjusted_move_speed: float

# singletons
var input_handler: InputHandler
var footstep_player: FootstepPlayer

# child nodes
var z_scaler: ZScaler 				= null
var player_sprite: AnimatedSprite2D = null
var player_state_chart: StateChart 	= null

var current_state: String 	= ""
var previous_state: String 	= ""

func _ready():
	input_handler 		= SingletonHolder.get_node("InputHandler")
	footstep_player 	= SingletonHolder.get_node("FootstepPlayer")
	player_sprite 		= $AnimatedSprite2D
	player_state_chart 	= $StateChart
	adjusted_move_speed = move_speed

func _process(delta):
	match current_state:
		"IDLE":
			pass
		"MOVING":
			if z_scaler and use_z_scaling:
				handle_scaling()
		"ENCOUNTER":
			pass
		"DIALOGUE":
			pass

func handle_footsteps():
	var current_frame = player_sprite.frame
	if footstep_frames.has(current_frame):
		footstep_player.play_random_footstep_sound()

func _physics_process(delta):
	
	# print(z_index)
	
	match current_state:
		"IDLE":
			if input_handler.move_input != Vector2.ZERO:
				player_state_chart.send_event("to_moving_event")
				return
		"MOVING":
			if input_handler.move_input == Vector2.ZERO:
				player_state_chart.send_event("to_idle_event")
				return
			handle_movement(input_handler.move_input)
			handle_footsteps()
			move_and_slide()
		"ENCOUNTER":
			pass
		"DIALOGUE":
			pass

func handle_movement(move_input: Vector2) -> void:
	velocity = move_input * adjusted_move_speed
	player_sprite.flip_h = (move_input.x < 0)
	handle_move_animation(move_input)

func handle_move_animation(move_input: Vector2) -> void:
	if move_input.x == 0 and move_input.y !=0: # if moving straight up or down
		if move_input.y > 0:
			player_sprite.play("walk_down")
		else:
			player_sprite.play("walk_up")
	elif move_input.x != 0 and move_input.y == 0: # if moving straight left or right
		player_sprite.play("walk_side")
	else:
		if move_input.y < 0:
			player_sprite.play("walk_up_side")
		else:
			player_sprite.play("walk_down_side")

func handle_scaling() -> void:
	if not z_scaler:
		push_warning("No ZScaler present")
		return
	var top_pos: Vector2 	= z_scaler.top_marker.global_position
	var bottom: Vector2 	= z_scaler.bottom_marker.global_position
	var adjusted_scale = z_scaler.get_adjusted_scale(global_position.y)
	scale = Vector2(adjusted_scale, adjusted_scale)
	
	var current_anim = player_sprite.animation
	var z_speed_adjustment = 1.0
	# if we are walking directly toward or away from the camera...
	if current_anim == "walk_up" or current_anim == "walk_down":
		z_speed_adjustment = 0.33
	# if we are walking diagonally...
	elif  current_anim == "walk_up_side" or current_anim == "walk_down_side":
		z_speed_adjustment = 0.66
	adjusted_move_speed = move_speed * adjusted_scale * z_speed_adjustment
	
	# fix the ordering
	player_sprite.z_index = int(global_position.y / 10)
	

func on_atomic_state_entered(new_state: String):
	match new_state:
		"IDLE":
			player_sprite.visible = true
			player_sprite.play("idle")
			if use_z_scaling:
				handle_scaling()
		"MOVING":
			pass
		"ENCOUNTER":
			player_sprite.visible = false
		"DIALOGUE":
			player_sprite.visible = true
			player_sprite.play("idle")
			if use_z_scaling:
				handle_scaling()
			
			
	previous_state = current_state
	current_state = new_state
	
	#print_debug("Current state: ", current_state, " -- Previous state: ", previous_state)	
	
	
