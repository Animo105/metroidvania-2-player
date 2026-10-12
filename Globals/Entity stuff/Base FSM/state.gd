@abstract extends Node
class_name State

var fsm : FSM

func enter(_previous_state : String)-> void:
	pass

func exit(_next_state : String)-> void:
	pass

@abstract func physics_update(_delta: float) -> void

func update(_delta : float) -> void:
	pass
