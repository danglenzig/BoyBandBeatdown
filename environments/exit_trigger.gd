extends Area2D

var main: Main = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if $"/root/Main":
		main = $"/root/Main"
	
	if not main:
		return
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
