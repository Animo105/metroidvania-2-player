extends Node2D

@onready var players_container: Node2D = $PlayersContainer
@onready var maps_container: Node2D = $Maps_container
@onready var camera_follow_2d: CameraFollow2D = $CameraFollow2D

var current_map

func _ready() -> void:
	current_map = maps_container.get_child(0)
	EventBus.player_entered_door.connect(_change_map_request)
	players_container.add_child(Globals.smoll_dude)
	players_container.add_child(Globals.big_dude)
	if Globals.is_smoll_dude:
		camera_follow_2d.target = Globals.smoll_dude
	else:
		camera_follow_2d.target = Globals.big_dude
	
	# check to init map

func _change_map_request(file : String, object_name : StringName):
	var packed_scene : PackedScene = load(file)
	var new_map : Level = packed_scene.instantiate()
	if not new_map : 
		push_error("File ",file, "couldn't be instantiated")
		return
	# fade in,
	# hide players
	var other_player := Globals.get_other_player_node()
	var self_player := Globals.get_self_player_node()
	other_player.visible = false
	self_player.visible = false
	Globals.self_map_id = new_map.level_id
	other_player_traveling_to.rpc_id(Globals.other_peer_id, new_map.level_id)
	# remove current map,
	# load new map,
	# fade out,

@rpc("any_peer", "call_remote", "reliable")
func other_player_traveling_to(next_map_id : String):
	print("Recived position update: ", next_map_id)
	Globals.other_map_id = next_map_id
	var other_player := Globals.get_other_player_node()
	if Globals.other_map_id == Globals.self_map_id:
		if other_player.get_parent() == null:
			LevelManager.current_level.add_child(other_player)
	else:
		if other_player.get_parent() != null:
			other_player.get_parent().remove_child(other_player)
