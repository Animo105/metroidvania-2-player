@abstract extends State
class_name PlayerState

var player : Player

var input: PlayerInputComponent:
	get(): return player.input_component
