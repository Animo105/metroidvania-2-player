extends CanvasLayer


signal animation_finished

@onready var color_rect: ColorRect = $ColorRect

var tween : Tween

func fade_in():
	if tween : tween.kill()
	tween = create_tween()
	tween.tween_property(color_rect, "self_modulate", Color(1,1,1,0), 0.2)
	tween.tween_callback(color_rect.hide)
	tween.tween_callback(animation_finished.emit)
	

func fade_out():
	if tween : tween.kill()
	tween = create_tween()
	tween.tween_callback(color_rect.show)
	tween.tween_property(color_rect, "self_modulate", Color(1,1,1,1), 0.2)
	tween.tween_callback(animation_finished.emit)
