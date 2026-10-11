extends Node

var current_level : Level


func change_to_level(file : String, exit_name : StringName):
	var packed_scene : PackedScene = load(file)
	
	var instance : Level = packed_scene.instantiate()
	if not instance : return
	var other_player_node = Globals.get_other_player_node()
	var self_player_node = Globals.get_self_player_node()
	if other_player_node.get_parent():
		other_player_node.get_parent().remove_child(other_player_node)
	if self_player_node.get_parent():
		self_player_node.get_parent().remove_child(self_player_node)
	SceneManager.load_from_node(instance)
	current_level = instance
	await current_level.ready
	current_level.add_child(self_player_node)
	for node in get_tree().get_nodes_in_group("TransitionPoint"):
		if node.name == exit_name:
			if node is TransitionSpace:
				self_player_node.global_position = node.spawn_point.global_position
			elif node is Marker2D:
				self_player_node.global_position  = node.global_position
	Globals.self_map_id = current_level.level_id
	Globals.rpc("sync_map", current_level.level_id)
	
