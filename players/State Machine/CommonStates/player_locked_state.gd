extends PlayerState
class_name PlayerLockedState

func enter(_previous_state : String)-> void:
	player.velocity.x = 0

func physics_update(delta: float) -> void:
	player.velocity.y += player.fall_gravity * delta
	player.move_and_slide()
	
	if player.allow_movement:
		fsm.change_state("grounded")
