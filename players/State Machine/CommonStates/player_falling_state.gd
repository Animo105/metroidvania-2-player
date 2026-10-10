extends PlayerState
class_name PlayerFallingState

func physics_update(delta: float) -> void:
	if player.is_on_floor():
		fsm.change_state("grounded")
		return

	var direction := Input.get_axis("move_left", "move_right")
	player.apply_horizontal_movement(direction, delta, true)
	player.velocity.y += player.fall_gravity * delta
	player.move_and_slide()
