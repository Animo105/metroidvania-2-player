extends Area2D
class_name TransitionSpace

enum SpaceType {
	DOOR,
	AREA
}

var can_enter

@export var space_type : SpaceType = SpaceType.AREA
@export_file("*.tscn") var toward_scene_path: String
@export var toward_object_name : String
@export var spawn_point : Marker2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_player_enter)
	body_exited.connect(_on_player_exit)

func _ready() -> void:
	add_to_group("TransitionPoint")
	if not spawn_point:
		for child in get_children():
			if child is Marker2D:
				spawn_point = child

func _on_player_enter(body : Node2D):
	if body is Player:
		can_enter = true
		if space_type == SpaceType.AREA:
			print(body.name, " Entered a new area")
			EventBus.player_entered_door.emit(body.owner_peer_id, toward_scene_path, toward_object_name)

func _on_player_exit(body : Node2D):
	if body is Player:
		can_enter = false
