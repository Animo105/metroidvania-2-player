extends FSM
class_name PlayerFSM

func _ready() -> void:
	var player := get_parent()
	for child in get_children():
		if child is PlayerState:
			child.player = player
			child.fsm = self
			states[child.name.to_lower()] = child
			
		else:
			child.queue_free()
			push_warning("State machine contains a none state object")
	if states.is_empty():
		queue_free()
	else:
		change_state(states.keys()[0])
