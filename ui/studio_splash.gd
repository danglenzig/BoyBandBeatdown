extends Control
class_name StudioSplash

var misc_tools: MiscTools

var studio_logo_tween: Tween
var glam_jam_tween: Tween

var studio_logo: CanvasItem
var glam_jam_logo: CanvasItem

const FADE_DURATION = 1.0
const SHOW_DURATION = 2.5

# Called when the node enters the scene tree for the first time.
func _ready():
	misc_tools = SingletonHolder.get_node("MiscTools")
	studio_logo = $Panel/StudioLogoLabel
	glam_jam_logo = $Panel/GlamJamTextureRect
	display_studio_logo()

func display_studio_logo():
	studio_logo.visible = true
	await  get_tree().create_timer(SHOW_DURATION).timeout
	studio_logo_tween = get_tree().create_tween()
	studio_logo_tween.tween_property(studio_logo,"self_modulate", Color(1,1,1,0),FADE_DURATION).set_ease(Tween.EASE_OUT)
	studio_logo_tween.tween_callback(display_glam_jam_logo)
	
	
func display_glam_jam_logo():
	studio_logo.visible = false
	glam_jam_logo.visible = true
	studio_logo_tween = null
	await  get_tree().create_timer(SHOW_DURATION).timeout
	glam_jam_tween = get_tree().create_tween()
	glam_jam_tween.tween_property(glam_jam_logo, "self_modulate", Color(1,1,1,0), FADE_DURATION).set_ease(Tween.EASE_OUT)
	glam_jam_tween.tween_callback(on_splash_finished)
	
func on_splash_finished():
	misc_tools.splash_complete.emit()
