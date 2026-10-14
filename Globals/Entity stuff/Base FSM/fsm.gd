extends Node
class_name FSM
signal on_state_change(new_state : String)

var states : Dictionary[String, State] = {}
var _current_state : State
var _current_state_key : String

func _register_state(child) -> bool:
	if child is State:
		child.fsm = self
		return true
	return false

func _ready() -> void:
	for child in get_children():
		if _register_state(child):
			states[child.name.to_lower()] = child
		else:
			child.queue_free()
			push_warning("State machine refused child: ", child)
	if states.is_empty():
		queue_free()
	else:
		change_state(states.keys()[0])

func get_current_state_string() -> String:
	return _current_state_key

func physics_update(delta:float)->void:
	_current_state.physics_update(delta)

func update(delta:float)->void:
	_current_state.update(delta)

func change_state(state_name : String)->void:
	if states.has(state_name):
		if _current_state_key == state_name:
			return
		if _current_state:
			_current_state.exit(state_name)
		_current_state = states[state_name]
		on_state_change.emit(state_name)
		_current_state.enter(_current_state_key)
		_current_state_key = state_name
