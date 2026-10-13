## Gère les espace de transition. À besoin d'une [class CollisionShape2D] et d'un [class Marker2D] en enfant pour fonctionner.
@tool
extends Area2D
class_name TransitionSpace

enum SpaceType {
	DOOR,
	AREA
}

var _can_enter


## Si space_type est AREA la transition sera fait dès que le player entre. si est DOOR, attend un input up.
@export var space_type : SpaceType = SpaceType.AREA
@export_enum("Custom", "Left", "Right") var exit_direction : String = "Custom" :
	set(value):
		exit_direction = value
		if _marker:
			if value == "Left":
				_marker.position = Vector2(-256, 128)
			elif value == "Right":
				_marker.position = Vector2(256, 128)
		

@export_group("Transition Data")
## File path de la scène a la quelle cette transition mène.
@export_file("*.tscn") var toward_scene_path: String
## Name of the object at which the transition lead[br]
## if object is a [class TransitionSpace], spawn at its marker. [br]
## if object is a [class Marker2D], spawn at that place.
@export var toward_object_name : String

var _marker : Marker2D

func set_player_position(player : Node2D):
	player.global_position = _marker.global_position

func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	var has_marker := false

	for child in get_children():
		if child is Marker2D:
			has_marker = true
			break

	if not has_marker:
		warnings.append("Ce noeud doit avoir un Marker2D comme enfant.")

	return warnings

func _init() -> void:
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_player_enter)
	body_exited.connect(_on_player_exit)

func _ready() -> void:
	if Engine.is_editor_hint():
		_setup_children()
	else:
		add_to_group("TransitionPoint")
		for child in get_children():
			if child is Marker2D:
				_marker = child

func _setup_children() -> void:
	var scene_root := get_tree().edited_scene_root
	if scene_root == null:
		return
	
	set_meta("_edit_group_", true)

	if not get_node_or_null("CollisionShape2D"):
		var collision := CollisionShape2D.new()
		add_child(collision, true)
		collision.owner = scene_root
		var shape : RectangleShape2D = RectangleShape2D.new()
		shape.size = Vector2(128,256)
		collision.shape = shape
	
	_marker = get_node_or_null("Marker2D")
	if not _marker:
		_marker = Marker2D.new()
		add_child(_marker, true)
		_marker.owner = scene_root

func _on_player_enter(body : Node2D):
	if body is Player:
		_can_enter = true
		if space_type == SpaceType.AREA:
			print(body.name, " Entered a new area")
			EventBus.player_entered_door.emit(body.owner_peer_id, toward_scene_path, toward_object_name)

func _on_player_exit(body : Node2D):
	if body is Player:
		_can_enter = false
