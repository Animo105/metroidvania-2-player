extends Node

enum Characters {
	SMOLL_GUY,
	BIG_GUY,
}
var smoll_dude : SmollDude
var big_dude : BigDude

var is_smoll_dude : bool

var self_peer_id : int
var other_peer_id : int

var self_map_id : String
var other_map_id : String

func _ready() -> void:
	var packed_smoll_dude : PackedScene = load("res://players/Smoll dude/player_1.tscn")
	var packed_big_dude : PackedScene = load("res://players/Big dude/player_2.tscn")
	smoll_dude = packed_smoll_dude.instantiate()
	big_dude = packed_big_dude.instantiate()

func get_other_player_node() -> Node2D:
	if is_smoll_dude:
		return big_dude
	else:
		return smoll_dude

func get_self_player_node() -> Node2D:
	if is_smoll_dude:
		return smoll_dude
	else:
		return big_dude

@rpc("any_peer", "call_local", "reliable")
func swap_characters():
	is_smoll_dude = not is_smoll_dude
	pass

func set_up_game():
	is_smoll_dude = true
	var peers := multiplayer.get_peers()
	if peers.size() != 1:
		print("Cant start game: peer number is wrong")
		return
	self_peer_id = multiplayer.get_unique_id()
	other_peer_id = peers[0]
	set_up_player.rpc(self_peer_id, other_peer_id)
	launch_game.rpc()

@rpc("authority", "call_local", "reliable")
func launch_game():
	SceneManager.load_from_file("res://game.tscn")

@rpc("authority", "call_local", "reliable")
func set_up_player(smoll_guy_id : int, big_guy_id : int):
	is_smoll_dude = (smoll_guy_id == multiplayer.get_unique_id())
	smoll_dude.setup_player(smoll_guy_id)
	big_dude.setup_player(big_guy_id)

@rpc("any_peer", "call_remote", "reliable")
func sync_map(map_id : String):
	print("Recived position update: ", map_id)
	other_map_id = map_id
	var other_player := get_other_player_node()
	if other_map_id == self_map_id:
		if other_player.get_parent() == null:
			LevelManager.current_level.add_child(other_player)
	else:
		if other_player.get_parent() != null:
			other_player.get_parent().remove_child(other_player)
