extends FSM
class_name PlayerFSM

func _register_state(child) -> bool:
	if child is PlayerState:
		child.fsm = self
		child.player = get_parent()
		return true
	return false
