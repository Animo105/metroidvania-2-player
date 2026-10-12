extends Node
class_name EntityAnimationComponent

@export var fsm : PlayerFSM

@export var animation_player : AnimationPlayer

var player : Entity

func _ready() -> void:
	if not fsm : return
	if not get_parent() is Entity:
		push_warning("PlayerAnimationComponent is not attached to a player")
		return
	player = get_parent()
	player.direction_changed.connect(_on_direction_change)

@export var current_animation : String : set = update_current_animation
@export var current_sprite_direction : String = "_right" : set = update_current_sprite_direction

func update_current_animation(new_animation : String):
	if current_animation == new_animation: return
	current_animation = new_animation
	animation_player.play(new_animation+current_sprite_direction)

func grounded_animation():
	
	if player.velocity == Vector2.ZERO:
		update_current_animation("idle")
	else:
		update_current_animation("walk")

func update_current_sprite_direction(new_sprite_direction : String):
	current_sprite_direction = new_sprite_direction
	var current_time := animation_player.current_animation_position
	animation_player.play(current_animation+current_sprite_direction)
	animation_player.seek(current_time, true)

func _on_direction_change(new_direction : float):
	current_sprite_direction = "_right" if new_direction > 0 else "_left"

func change_sprite_direction():
	pass
		

func _process(_delta: float) -> void:
	if not player: return
	if not fsm: return
	match fsm.get_current_state_string():
		"grounded":
			grounded_animation()
		"jump":
			update_current_animation("jump")
		"falling":
			update_current_animation("fall")
