extends Panel

class_name HudPanel
var help_rect: TextureRect
var toggle_help_button: Button

# Called when the node enters the scene tree for the first time.
func _ready():
	help_rect = get_parent().get_node("HelpRect")
	toggle_help_button = $ToggleHelpButton

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func display_toggle_help_button(the_bool: bool):
	toggle_help_button.visible = the_bool

func _on_toggle_help_button_pressed():
	help_rect.visible = !help_rect.visible
