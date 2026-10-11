extends Node
class_name PlayerInputComponent

var move_direction: float = 0.0
var jump_pressed: bool = false

var player: Player

func _process(_delta: float) -> void:
	if not player: return
	
	if player.is_local_player:
		move_direction = Input.get_axis("move_left", "move_right")
		jump_pressed = Input.is_action_pressed("jump")

func _physics_process(_delta: float) -> void:
	if not player: return
	prints(name,": jump",jump_pressed,", direction",move_direction)
	if not multiplayer.is_server():
		submit_inputs.rpc_id(1, move_direction, jump_pressed)

@rpc("any_peer", "call_remote", "unreliable")
func submit_inputs(direction: float, jump: bool) -> void:
	if not multiplayer.is_server(): return
	print("Recived inputs")
	if player.owner_peer_id == multiplayer.get_remote_sender_id():
		print("update inputs")
		move_direction = direction
		jump_pressed = jump
