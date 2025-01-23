extends CharacterBody2D
class_name Player

var misc: MiscTools = SingletonHolder.get_node("MiscTools")

@export var move_speed: float 	= 300.0
@export var use_z_scaling: bool = true
@export var footstep_frames: Array[int]

@export var ally_scene: PackedScene
@export var ally_spawn_distance = 30

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
	misc.player_on_exit_cooldown = true
	misc.start_exit_cooldown()
	misc.current_player = self
	input_handler 		= SingletonHolder.get_node("InputHandler")
	footstep_player 	= SingletonHolder.get_node("FootstepPlayer")
	player_sprite 		= $AnimatedSprite2D
	player_state_chart 	= $StateChart
	adjusted_move_speed = move_speed
	
	await get_tree().create_timer(0.1).timeout
	spawn_ally()
	

func _process(_delta):
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

func spawn_ally()->void:
	
	var main: Main = misc.main
	if not main:
		push_error("no main")
		return
	if not main.current_environment:
		push_error("no environment")
		return
	if not main.current_environment.has_node("NavigationRegion2D") or not main.current_environment.has_node("AllyHolder"):
		push_error("no na region or ally holder")
		return
	var center_marker: Marker2D = main.current_environment.get_node("NavigationRegion2D").get_node("CenterMarker")
	var direction: Vector2 = (center_marker.global_position - global_position).normalized()
	var spawn_pos = global_position + (direction * ally_spawn_distance * scale.length())
	
	var new_ally: NpcAlly = ally_scene.instantiate()
	new_ally.visible = false
	await get_tree().create_timer(0.1).timeout
	
	if main.current_environment.ally_marker_name != "":
		var ally_marker: Marker2D = main.current_environment.get_node("NavigationRegion2D").get_node("BackupAllyStart")
		new_ally.global_position = ally_marker.global_position
	else:
		new_ally.global_position = spawn_pos
	main.current_environment.get_node("AllyHolder").call_deferred("add_child", new_ally)
	
	while not new_ally.first_scaling:
		await get_tree().create_timer(0.1).timeout
	new_ally.visible = true
	
	
	
	
func handle_footsteps():
	var current_frame = player_sprite.frame
	if footstep_frames.has(current_frame):
		footstep_player.play_random_footstep_sound()

func _physics_process(_delta):
	
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
	var _top_pos: Vector2 	= z_scaler.top_marker.global_position
	var _bottom: Vector2 	= z_scaler.bottom_marker.global_position
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
	
	
