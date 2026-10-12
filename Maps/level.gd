@tool
extends Node2D
class_name Level

@export var level_id : String

@export var limit_left: int = -5000:
	set(value):
		limit_left = value
		queue_redraw()
@export var limit_top: int = -5000:
	set(value):
		limit_top = value
		queue_redraw()
@export var limit_right: int = 5000:
	set(value):
		limit_right = value
		queue_redraw()
@export var limit_bottom: int = 5000:
	set(value):
		limit_bottom = value
		queue_redraw()

func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var rect := Rect2(
		Vector2(limit_left, limit_top),
		Vector2(limit_right - limit_left, limit_bottom - limit_top)
	)
	draw_rect(rect, Color(0.2, 0.8, 1.0), false, 5)
