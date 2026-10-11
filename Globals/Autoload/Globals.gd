extends Node

enum Characters {
	SMOLL_GUY,
	BIG_GUY,
}

func set_multiplayer_priority():
	pass

var smoll_dude : SmollDude
var big_dude : BigDude

var is_smoll_dude : bool

var self_peer_id : int
var other_peer_id : int

var self_map_id : String
var other_map_id : String

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

func _ready() -> void:
	var packed_smoll_dude : PackedScene = load("res://players/Smoll dude/player_1.tscn")
	var packed_big_dude : PackedScene = load("res://players/Big dude/player_2.tscn")
	smoll_dude = packed_smoll_dude.instantiate()
	big_dude = packed_big_dude.instantiate()

func apply_authority():
	if is_smoll_dude:
		big_dude.update_authority(other_peer_id)
		smoll_dude.update_authority(self_peer_id)
	else:
		smoll_dude.update_authority(other_peer_id)
		big_dude.update_authority(self_peer_id)

@rpc("any_peer", "call_local", "reliable")
func swap_characters():
	is_smoll_dude = not is_smoll_dude
	apply_authority()

@rpc("authority", "call_local", "reliable")
func launch_game():
	print("LAUNCHING GAME!!")
	is_smoll_dude = true if Network.is_owner else false
	var peers := multiplayer.get_peers()
	if peers.size() != 1: return
	Globals.self_peer_id= multiplayer.get_unique_id()
	Globals.other_peer_id = peers[0]
	apply_authority()
	LevelManager.change_to_level("res://Maps/test/starting_test.tscn", "StartingPoint")

@rpc("any_peer", "call_remote", "reliable")
func sync_map(map_id : String):
	other_map_id = map_id
	var other_player := get_other_player_node()
	if other_map_id == self_map_id:
		if other_player.get_parent() != null:
			LevelManager.current_level.add_child(other_player)
	else:
		if other_player.get_parent() != null:
			other_player.get_parent().remove_child(other_player)
