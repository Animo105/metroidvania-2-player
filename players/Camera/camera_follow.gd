extends Camera2D
class_name CameraFollow2D

var target : Node2D

func _process(_delta: float) -> void:
	if not target: return
	global_position = target.global_position
