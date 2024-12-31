extends Node


var input_handler: InputHandler

var my_array = ["A","B","C","D","E"]
var ta = 0
var ui = 0.05

# Called when the node enters the scene tree for the first time.
func _ready():
	input_handler = SingletonHolder.get_node("InputHandler")


func pick_a_rando():
	var a_rando = randi_range(0,my_array.size()-1)
	print(a_rando)

func _process(delta):
	ta += delta
	if ta < ui:
		return
	pick_a_rando()
	
	
