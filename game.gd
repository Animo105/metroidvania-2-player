extends Node2D

@onready var players_container: Node2D = $PlayersContainer
@onready var maps_container: Node2D = $Maps_container
@onready var camera_follow_2d: CameraFollow2D = $CameraFollow2D


func _ready() -> void:
	players_container.add_child(Globals.smoll_dude)
	players_container.add_child(Globals.big_dude)
	if Globals.is_smoll_dude:
		camera_follow_2d.target = Globals.smoll_dude
	else:
		camera_follow_2d.target = Globals.big_dude
