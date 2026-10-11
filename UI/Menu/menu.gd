extends Control


func _on_button_pressed() -> void:
	Network.host_lobby()


func _on_button_2_pressed() -> void:
	SceneManager.load_from_file("res://game.tscn")
