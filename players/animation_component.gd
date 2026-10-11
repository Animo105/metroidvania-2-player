extends Node
class_name AnimationComponent

@export var fsm : PlayerFSM

@export var legs_animation_player : AnimationPlayer
@export var body_animation_player : AnimationPlayer

func _ready() -> void:
	if not fsm : return
	fsm.on_state_change.connect(_on_state_change)

func _on_state_change(new_state : String):
	pass
