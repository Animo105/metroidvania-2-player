extends Area2D
class_name TransitionSpace

enum SpaceType {
	DOOR,
	AREA
}

var can_enter

@export var space_type : SpaceType = SpaceType.DOOR
@export_file("*.tscn") var toward_scene_path: String
@export var toward_transition_space_name : StringName
@export var spawn_point : Marker2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_player_enter)
	body_exited.connect(_on_player_exit)

func _ready() -> void:
	add_to_group("TransitionPoint")
	print(get_tree().get_nodes_in_group("TransitionPoint"))

func _on_player_enter(body : Node2D):
	if not body is Player: return
	can_enter = true
	if space_type == SpaceType.AREA:
		do_transition()

func _on_player_exit(body : Node2D):
	if not body is Player: return
	can_enter = false

func do_transition():
	LevelManager.change_to_level(toward_scene_path, toward_transition_space_name)
