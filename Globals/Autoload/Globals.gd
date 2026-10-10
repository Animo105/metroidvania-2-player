extends Node

func set_multiplayer_priority():
	pass

var smoll_dude : SmollDude
var big_dude : BigDude

var is_smoll_dude : bool

var self_peer_id : int
var other_peer_id : int

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
	is_smoll_dude = true if Network.is_owner else false
	SceneManager.load_from_file("res://Maps/Map.tscn")
