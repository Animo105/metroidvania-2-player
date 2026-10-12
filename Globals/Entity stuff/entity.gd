@abstract extends CharacterBody2D
class_name Entity

signal direction_changed(new_direction : float)

@export_group("Movement")
@export var move_speed: float = 400.0
@export var air_speed: float = 400.0

@export_group("Jump")
@export var rise_gravity: float = 980.0
@export var fall_gravity: float = 1400.0
@export var jump_velocity: float = -650.0
@export var coyote_time: float = 0.12

var coyote_timer: float = 0.0

var speed_multiplier: float = 1.0
var airborn_multiplier: float = 1.0
var jump_multiplier: float = 1.0

var last_direction : float = 0:
	set(value):
		if last_direction != value:
			last_direction = value
			direction_changed.emit(value)
