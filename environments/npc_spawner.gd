extends Node
class_name NpcSpawner

@export var npc_scenes	: Array[PackedScene]

var qty_to_spawn		: int
var spawned_npcs		: Array[NpcSprite]
var environment			: GameEnvironment
var npc_holder			: Node2D
var spawn_markers		: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_markers = $SpawnMarkers.get_children()
	environment 	= get_parent()
	npc_holder = environment.get_node("NpcHolder")
	qty_to_spawn 	= npc_scenes.size()


func clear_npcs():
	var current_npcs = npc_holder.get_children()
	for npc: NpcSprite in current_npcs:
		npc.call_deferred("queue_free")
		
func spawn_npcs():
	if qty_to_spawn > spawn_markers.size():
		push_error("Not enough spawn markers")
		return
	# TODO: finish this
