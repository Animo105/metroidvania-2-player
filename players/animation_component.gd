extends Node
class_name PlayerAnimationComponent

@export var fsm : PlayerFSM

@export var legs_animation_player : AnimatedSprite2D
@export var body_animation_player : AnimatedSprite2D

var player : Player

var sprite_direction : float = 1

func _ready() -> void:
	if not fsm : return
	if not get_parent() is Player:
		push_warning("PlayerAnimationComponent is not attached to a player")
		return
	player = get_parent()

var current_animation : String : set = update_current_animation


func update_current_animation(new_animation : String):
	if current_animation == new_animation: return
	current_animation = new_animation
	legs_animation_player.play(new_animation)
	body_animation_player.play(new_animation)

func grounded_animation():
	if player.velocity == Vector2.ZERO:
		update_current_animation("idle")
	else:
		update_current_animation("walk")

func change_sprite_direction():
	if player.last_direction != sprite_direction:
		sprite_direction = player.last_direction
		legs_animation_player.flip_h = sprite_direction < 0
		body_animation_player.flip_h = sprite_direction < 0

func _process(_delta: float) -> void:
	if not player: return
	if not fsm: return
	change_sprite_direction()
	match fsm.get_current_state_string():
		"grounded":
			grounded_animation()
		"jump":
			update_current_animation("jump")
		"falling":
			update_current_animation("fall")
