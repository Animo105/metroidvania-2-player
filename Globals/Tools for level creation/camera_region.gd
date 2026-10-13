@tool
extends Area2D
class_name CameraRegion

var _limits : Rect2

func _ready() -> void:
	if Engine.is_editor_hint():
		_setup_children()
	else:
		body_entered.connect(_on_body_entered)
		collision_layer = 0
		collision_mask = 4
		var col : CollisionShape2D
		for child in get_children():
			if child is CollisionShape2D:
				col = child
				break
		var shape : RectangleShape2D = col.shape as RectangleShape2D
		_limits = Rect2(col.global_position - shape.size/2, shape.size)
		


func _setup_children():
	var scene_root := get_tree().edited_scene_root
	if scene_root == null:
		return
	
	if not get_node_or_null("CollisionShape2D"):
		var collision := CollisionShape2D.new()
		add_child(collision, true)
		collision.owner = scene_root
		var shape : RectangleShape2D = RectangleShape2D.new()
		shape.size = Vector2(256,256)
		collision.shape = shape

func _on_body_entered(body : Node2D):
	if body is Player:
		if not body.is_local_player: return
		EventBus.update_camera_limits.emit(_limits)
		
