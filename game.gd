extends Node2D

@onready var players_container: Node2D = $PlayersContainer
@onready var maps_container: Node2D = $Maps_container
@onready var camera_follow_2d: CameraFollow2D = $CameraFollow2D

var current_map : Level

func _ready() -> void:
	current_map = maps_container.get_child(0)
	EventBus.player_entered_door.connect(_change_map_request)
	players_container.add_child(Globals.smoll_dude)
	players_container.add_child(Globals.big_dude)
	camera_follow_2d.target = Globals.get_self_player_node()
	
	Globals.self_map_id = "testing_zone_1"
	Globals.other_map_id = "testing_zone_1"
	apply_cam_limit()
	# check to init map

func apply_cam_limit():
	camera_follow_2d.limit_bottom = current_map.limit_bottom
	camera_follow_2d.limit_left = current_map.limit_left
	camera_follow_2d.limit_right = current_map.limit_right
	camera_follow_2d.limit_top = current_map.limit_top

func _change_map_request(peer_id : int, file : String, object_name : StringName):
	if peer_id != multiplayer.get_unique_id() : return
	
	var packed_scene : PackedScene = load(file)
	var new_map : Level = packed_scene.instantiate()
	if not new_map : 
		push_error("File ",file, "couldn't be instantiated")
		return

	# fade in,

	var other_player := Globals.get_other_player_node()
	var self_player := Globals.get_self_player_node()
	other_player.visible = false
	self_player.visible = false

	Globals.self_map_id = new_map.level_id
	other_player_traveling_to.rpc_id(Globals.other_peer_id, new_map.level_id)
	current_map.queue_free()
	current_map = new_map
	maps_container.add_child.call_deferred(new_map)
	
	await current_map.ready
	apply_cam_limit()
	for node : Node2D in get_tree().get_nodes_in_group("TransitionPoint"):
		if node.name != object_name: continue
		print("found the node")
		if node is TransitionSpace:
			print("exit through transition space")
			node.set_player_position(self_player)
			camera_follow_2d.reset_smoothing()
			break
		elif node is Marker2D:
			print("exit through marker")
			self_player.global_position = node.global_position
			camera_follow_2d.reset_smoothing()
			break
	
	self_player.visible = true
	if Globals.self_map_id == Globals.other_map_id:
		other_player.visible = true
	
	# fade out,

@rpc("any_peer", "call_remote", "reliable")
func other_player_traveling_to(next_map_id : String):
	print("Recived position update from ", multiplayer.get_remote_sender_id())
	var other_player := Globals.get_other_player_node()

	if Globals.other_map_id == Globals.self_map_id:
		if not current_map.is_multiplayer_authority():
			current_map.set_multiplayer_authority(Globals.self_peer_id, true)
		other_player.visible = false
	
	Globals.other_map_id = next_map_id
	
	if Globals.other_map_id == Globals.self_map_id:
		other_player.visible = true
