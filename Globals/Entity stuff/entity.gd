@abstract extends CharacterBody2D
class_name Entity

signal direction_changed(new_direction : float)

@export_group("Movement")
@export var move_speed: float = 600.0
@export var air_speed: float = 550.0

@export_group("Jump")
@export var up_speed: float = 1500.0
@export var target_height: float = 384.0
@export var fall_gravity_multiplier: float = 1.2
@export var coyote_time : float = 0.12

@onready var rise_gravity : float = pow(up_speed, 2) / (2.0 * target_height)
@onready var fall_gravity : float = rise_gravity * fall_gravity_multiplier

var coyote_timer: float = 0.0

var speed_multiplier: float = 1.0
var airborn_multiplier: float = 1.0
var jump_multiplier: float = 1.0

var last_direction : float = 0:
	set(value):
		if last_direction != value:
			last_direction = value
			direction_changed.emit(value)
