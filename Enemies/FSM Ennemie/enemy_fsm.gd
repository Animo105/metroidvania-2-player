extends FSM
class_name EnnemyFSM

func _register_state(child) -> bool:
	if child is EnemyState:
		child.fsm = self
		child.player = get_parent()
		return true
	return false
