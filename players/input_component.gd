extends Node
class_name PlayerInputComponent

var move_direction: float = 0.0
var jump_pressed: bool = false

@export var player: Player

func _ready() -> void:
	if not player:
		if not get_parent() is Player:
			push_error("PlayerInputComponent without a player")
			queue_free()
			return
		player = get_parent()

func _process(_delta: float) -> void:
	if player.is_local_player:
		move_direction = Input.get_axis("move_left", "move_right")
		jump_pressed = Input.is_action_pressed("jump")

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		print("jumped")
	if not multiplayer.is_server():
		submit_inputs.rpc_id(1, move_direction, jump_pressed)

@rpc("any_peer", "call_remote", "unreliable")
func submit_inputs(direction: float, jump: bool) -> void:
	if not multiplayer.is_server(): return
	print("INPUT RECIEVED")
	print("direction: ", direction)
	print("jump: ", jump)
	if get_multiplayer_authority() == multiplayer.get_remote_sender_id():
		move_direction = direction
		jump_pressed = jump
