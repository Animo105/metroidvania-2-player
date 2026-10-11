extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var move_speed: float = 400.0
@export var acceleration: float = 1500.0
@export var deceleration: float = 2000.0

@export_group("Air Movement")
@export var air_speed: float = 400.0
@export var air_acceleration: float = 900.0
@export var air_deceleration: float = 400.0

@export_group("Jump")
@export var rise_gravity: float = 980.0
@export var fall_gravity: float = 1400.0
@export var jump_velocity: float = -650.0
@export var coyote_time: float = 0.12

var speed_multiplier: float = 1.0
var airborn_multiplier: float = 1.0
var jump_multiplier: float = 1.0

var coyote_timer: float = 0.0

var fsm : PlayerFSM
var input_component : PlayerInputComponent

var owner_peer_id: int
var is_local_player := false

func _ready() -> void:
	for child in get_children():
		if child is PlayerFSM:
			fsm = child
		elif child is PlayerInputComponent:
			input_component = child
			input_component.player = self
	is_local_player = (multiplayer.get_unique_id() == owner_peer_id)
	print(is_local_player)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		fsm.physics_update(delta)
	elif is_local_player:
		fsm.physics_update(delta)

func _process(delta: float) -> void:
	if multiplayer.is_server():
		fsm.update(delta)
	elif is_local_player:
		fsm.update(delta)

func setup_player(peer_id: int) -> void:
	owner_peer_id = peer_id

func apply_horizontal_movement( direction: float, delta: float, in_air: bool) -> void:
	var target_speed: float = 0
	
	if in_air:
		target_speed = direction * air_speed * speed_multiplier * airborn_multiplier
	else:
		target_speed = direction * move_speed * speed_multiplier
	
	var accel = air_acceleration if in_air else acceleration
	var decel = air_deceleration if in_air else deceleration
	
	if direction == 0.0:
		velocity.x = move_toward(velocity.x, 0.0, decel * delta)
	else:
		velocity.x = move_toward(velocity.x, target_speed, accel * delta)
