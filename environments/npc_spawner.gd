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
	
	spawn_npcs()


func clear_npcs():
	var current_npcs = npc_holder.get_children()
	for npc: NpcSprite in current_npcs:
		npc.call_deferred("queue_free")
		
func spawn_npcs():
	if qty_to_spawn > spawn_markers.size():
		push_error("Not enough spawn markers")
		return
	
	var selected_markers: Array[Marker2D] = []
	while selected_markers.size() < qty_to_spawn:
		var a_rando = randi_range(0, spawn_markers.size() - 1)
		if spawn_markers[a_rando] not in selected_markers:
			selected_markers.append(spawn_markers[a_rando])
			
	for i in range(0,qty_to_spawn):
		
		var this_scene:PackedScene = npc_scenes[i]
		var this_marker = selected_markers[i]
		var new_npc: NpcSprite = this_scene.instantiate()
		new_npc.visible = false
		new_npc.z_scaler = environment.get_node("ZScaler")
		npc_holder.call_deferred("add_child", new_npc)
		
		await get_tree().create_timer(0.1).timeout
		
		new_npc.global_position = this_marker.global_position
		new_npc.visible = true
