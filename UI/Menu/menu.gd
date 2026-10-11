extends Control


func _on_button_pressed() -> void:
	Network.host_lobby()


func _on_button_2_pressed() -> void:
	LevelManager.change_to_level("res://Maps/OvergrownWall/starting_test.tscn", "StartingPoint")
