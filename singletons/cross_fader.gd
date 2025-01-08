extends Node
class_name CrossFader

@export var outdoor_music_db 	= 0.0
@export var indoor_music_db 	= 0.0
@export var start_menu_music_db = 0.0
@export var battle_music_db 	= 0.0
@export var off_db 				= -80
@export var fade_duration 		= 3.0

var indoor_index 		= AudioServer.get_bus_index("IndoorMusic")
var outdoor_index 		= AudioServer.get_bus_index("OutdoorMusic")
var battle_index 		= AudioServer.get_bus_index("BattleMusic")
var start_menu_index 	= AudioServer.get_bus_index("StartMenuMusic")

var current_music: String 			= ""
var current_outdoor_tween: Tween 	= null
var current_indoor_tween: Tween 	= null
var current_battle_tween: Tween 	= null
var current_start_menu_tween: Tween = null
var tween_index: int 				= 0
var time_accumulator 				= 0
var update_interval 				= 0.1
var is_tweening: bool 				= false

@export var indoor_volume: float:
	get: return AudioServer.get_bus_volume_db(indoor_index)
	set(value):
		AudioServer.set_bus_volume_db(indoor_index, value)
@export var outdoor_volume: float:
	get: return AudioServer.get_bus_volume_db(outdoor_index)
	set(value):
		AudioServer.set_bus_volume_db(outdoor_index, value)
@export var battle_volume: float:
	get: return AudioServer.get_bus_volume_db(battle_index)
	set(value):
		AudioServer.set_bus_volume_db(battle_index, value)
@export var start_menu_volume: float:
	get: return AudioServer.get_bus_volume_db(start_menu_index)
	set(value):
		AudioServer.set_bus_volume_db(start_menu_index, value)

const FADE_IN_MODIFIER 			= 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(start_menu_index, start_menu_music_db)
	AudioServer.set_bus_volume_db(outdoor_index, off_db)
	AudioServer.set_bus_volume_db(indoor_index, off_db)
	AudioServer.set_bus_volume_db(battle_index, off_db)

func _process(delta):
	time_accumulator += delta
	if time_accumulator < update_interval:
		return
	time_accumulator = 0
	
	if is_tweening:
		print_debug(tween_index,": ", "IndoorMusic: ", get_volume(indoor_index)," OutdoorMusic: ", get_volume(outdoor_index), " BattleMusic: ", get_volume(battle_index), " StartMenuMusic: ", get_volume(start_menu_index))
		tween_index += 1
		

func fade_to_indoor_music(indoor_tween: Tween, outdoor_tween: Tween, battle_tween: Tween, start_menu_tween: Tween)->void:
	current_indoor_tween 		= indoor_tween
	current_outdoor_tween 		= outdoor_tween
	current_battle_tween 		= battle_tween
	current_start_menu_tween 	= start_menu_tween
	
	# fade in...
	indoor_tween.tween_property(self, "indoor_volume", indoor_music_db, fade_duration * FADE_IN_MODIFIER)
	# fade out...
	outdoor_tween.tween_property(self, "outdoor_volume",off_db, fade_duration)
	battle_tween.tween_property(self, "battle_volume", off_db, fade_duration)
	start_menu_tween.tween_property(self, "start_menu_volume", off_db, fade_duration)
	# clean up
	start_menu_tween.tween_callback(on_tween_complete)
	
func fade_to_outdoor_music(indoor_tween: Tween, outdoor_tween: Tween, battle_tween: Tween, start_menu_tween: Tween)->void:
	current_indoor_tween 		= indoor_tween
	current_outdoor_tween 		= outdoor_tween
	current_battle_tween 		= battle_tween
	current_start_menu_tween 	= start_menu_tween
	
	# fade in...
	outdoor_tween.tween_property(self, "outdoor_volume", outdoor_music_db, fade_duration * FADE_IN_MODIFIER)
	# fade out...
	indoor_tween.tween_property(self, "indoor_volume", off_db, fade_duration)
	battle_tween.tween_property(self, "battle_volume", off_db, fade_duration)
	start_menu_tween.tween_property(self, "start_menu_volume", off_db, fade_duration)
	# clean up
	start_menu_tween.tween_callback(on_tween_complete)
	
func fade_to_battle_music(indoor_tween: Tween, outdoor_tween: Tween, battle_tween: Tween, start_menu_tween: Tween)->void:
	current_indoor_tween 		= indoor_tween
	current_outdoor_tween 		= outdoor_tween
	current_battle_tween 		= battle_tween
	current_start_menu_tween 	= start_menu_tween
	
	# fade in...
	battle_tween.tween_property(self, "battle_volume", battle_music_db, fade_duration * FADE_IN_MODIFIER)
	# fade out...
	indoor_tween.tween_property(self, "indoor_volume", off_db, fade_duration)
	outdoor_tween.tween_property(self, "outdoor_volume", off_db, fade_duration)
	start_menu_tween.tween_property(self, "start_menu_volume", off_db, fade_duration)
	# clean up
	start_menu_tween.tween_callback(on_tween_complete)
	
func fade_to_start_menu_music(indoor_tween: Tween, outdoor_tween: Tween, battle_tween: Tween, start_menu_tween: Tween)->void:
	current_indoor_tween 		= indoor_tween
	current_outdoor_tween 		= outdoor_tween
	current_battle_tween 		= battle_tween
	current_start_menu_tween 	= start_menu_tween
	
	# fade in...
	start_menu_tween.tween_property(self, "start_menu_volume", start_menu_music_db, fade_duration * FADE_IN_MODIFIER)
	# fade out...
	indoor_tween.tween_property(self, "indoor_volume", off_db, fade_duration)
	outdoor_tween.tween_property(self, "outdoor_volume", off_db, fade_duration)
	battle_tween.tween_property(self, "battle_volume", off_db, fade_duration)
	# clean up
	battle_tween.tween_callback(on_tween_complete)

func fade_to_music(bus_name: String)->void:
	print_debug("Fading to music bus: ", bus_name)
	
	# ignore if we're already tweening this tween
	if bus_name == current_music:
		return
	
	# stop all running tweens
	if current_indoor_tween:
		current_indoor_tween.stop()
	if current_outdoor_tween:
		current_outdoor_tween.stop()
	if current_battle_tween:
		current_battle_tween.stop()
	if current_start_menu_tween:
		current_start_menu_tween.stop()
		
	current_music = bus_name
	is_tweening = true
	tween_index = 0
	
	var indoor_tween 			= get_tree().create_tween()
	var outdoor_tween 			= get_tree().create_tween()
	var battle_tween 			= get_tree().create_tween()
	var start_menu_tween 		= get_tree().create_tween()
	
	match  bus_name:
		"IndoorMusic":
			fade_to_indoor_music(indoor_tween, outdoor_tween, battle_tween, start_menu_tween)
		"OutdoorMusic":
			fade_to_outdoor_music(indoor_tween, outdoor_tween, battle_tween, start_menu_tween)
		"BattleMusic":
			fade_to_battle_music(indoor_tween, outdoor_tween, battle_tween, start_menu_tween)
		"StartMenuMusic":
			fade_to_start_menu_music(indoor_tween, outdoor_tween, battle_tween, start_menu_tween)

func on_tween_complete():
	is_tweening = false

func bus_volume_helper(bus_name: String, volume_db: float)->void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, volume_db)
	
func get_volume(bus_index: int)->float:
	return AudioServer.get_bus_volume_db(bus_index)
	

	
