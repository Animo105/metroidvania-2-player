extends Node
class_name PlayerAnimationComponent

@export var fsm : PlayerFSM

@export var legs_animation_player : AnimatedSprite2D
@export var body_animation_player : AnimatedSprite2D

var player : Player

func _ready() -> void:
	if not fsm : return
	if not get_parent() is Player:
		push_warning("PlayerAnimationComponent is not attached to a player")
		return
	player = get_parent()
	#fsm.on_state_change.connect(_on_state_change)

var current_animation : String : set = update_current_animation

func update_current_animation(new_animation : String):
	if current_animation == new_animation: return
	current_animation = new_animation
	legs_animation_player.play(new_animation)
	body_animation_player.play(new_animation)
	print("playing ", new_animation)

func _process(delta: float) -> void:
	if not player: return
	if player.velocity == Vector2.ZERO:
		update_current_animation("idle")
	else:
		update_current_animation("walk")
