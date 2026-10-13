extends Node
class_name FuckLeMultiComponent

@export var is_smoll_dude : bool = true
@export var wanted_scene : PackedScene

func _ready() -> void:
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer :
		Globals.is_smoll_dude = is_smoll_dude
		Globals.self_peer_id = 1
		if is_smoll_dude:
			Globals.smoll_dude.is_local_player = true
			Globals.smoll_dude.owner_peer_id = 1
		else:
			Globals.big_dude.is_local_player = true
			Globals.big_dude.owner_peer_id = 1
	
	var game := get_parent()
	var map_container = game.get_node_or_null("Maps_container")
	if map_container:
		var current_map = map_container.get_child(0)
		map_container.remove_child(current_map)
		current_map.queue_free()
	map_container.add_child(wanted_scene.instantiate())
		
	
