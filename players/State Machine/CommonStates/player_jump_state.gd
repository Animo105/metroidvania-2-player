extends PlayerState
class_name PlayerJumpState

func enter(_previous_state: String) -> void:
	player.velocity.y = -player.up_speed * player.jump_multiplier

func physics_update(delta: float) -> void:
	if not Input.is_action_pressed("jump") and player.velocity.y < 0.0:
		player.velocity.y = 0.0
		fsm.change_state("falling")
		return

	var direction := Input.get_axis("move_left", "move_right")
	player.apply_horizontal_movement(direction, delta, true)

	player.velocity.y += player.rise_gravity * delta
	player.move_and_slide()

	if player.velocity.y >= 0.0:
		fsm.change_state("falling")
