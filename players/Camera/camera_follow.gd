extends Camera2D
class_name CameraFollow2D

const FORWARD_OFFSET :int = 50

var target : Player

func _process(_delta: float) -> void:
	if not target: return
	global_position = target.global_position
	global_position.x += (target.last_direction * FORWARD_OFFSET)
	global_position.y -= 80
