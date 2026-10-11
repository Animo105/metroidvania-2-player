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
