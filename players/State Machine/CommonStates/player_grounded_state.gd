extends PlayerState
class_name PlayerGroundedState

func enter(_previous_state: String) -> void:
	if Input.is_action_pressed("jump"):
		fsm.change_state("jump")

func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		fsm.change_state("jump")
		return

	var direction := Input.get_axis("move_left", "move_right")
	player.apply_horizontal_movement(direction, delta, false)
	player.move_and_slide()

	if not player.is_on_floor():
		player.coyote_timer = maxf(0.0, player.coyote_timer - delta)
		if player.coyote_timer <= 0.0:
			fsm.change_state("falling")
	else:
		player.coyote_timer = player.coyote_time
