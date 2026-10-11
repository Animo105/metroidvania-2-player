extends PlayerState
class_name PlayerGroundedState

func physics_update(delta: float) -> void:
	if input.jump_pressed:
		fsm.change_state("jump")
		return

	var direction := input.move_direction
	player.apply_horizontal_movement(direction, delta, false)
	player.move_and_slide()

	if not player.is_on_floor():
		player.coyote_timer = maxf(0.0, player.coyote_timer - delta)
		if player.coyote_timer <= 0.0:
			fsm.change_state("falling")
	else:
		player.coyote_timer = player.coyote_time
