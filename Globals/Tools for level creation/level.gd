@tool
extends Node2D
class_name Level

@export var level_id : String

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	_setup_children()

func _setup_children() -> void:
	var scene_root := get_tree().edited_scene_root
	if scene_root == null:
		return
	
	var tile_maps_container : Node2D = get_node_or_null("TileMapsContainer")
	if tile_maps_container == null:
		var tileset = load("res://Assets/tileset.tres")
		tile_maps_container = Node2D.new()
		tile_maps_container.name = "TileMapsContainer"
		add_child(tile_maps_container, true)
		tile_maps_container.owner = scene_root
		var tile_map := tile_maps_container.get_node_or_null("TileMapLayer")
		if tile_map == null:
			tile_map = TileMapLayer.new()
			tile_map.name = "TileMapLayer"
			tile_maps_container.add_child(tile_map, true)
			tile_map.tile_set = tileset
			tile_map.owner = scene_root
	
	var camera_regions : Node2D = get_node_or_null("CameraRegions")
	if camera_regions == null:
		camera_regions = Node2D.new()
		camera_regions.name = "CameraRegions"
		add_child(camera_regions, true)
		camera_regions.owner = scene_root
	
	var transition_points_container : Node2D = get_node_or_null("TransitionPointsContainer")
	if transition_points_container == null:
		transition_points_container = Node2D.new()
		transition_points_container.name = "TransitionPointsContainer"
		add_child(transition_points_container, true)
		transition_points_container.owner = scene_root
