extends Control


func _on_button_pressed() -> void:
	Network.host_lobby()


func _on_button_host_local_pressed() -> void:
	Network.host_local()


func _on_button_join_local_pressed() -> void:
	Network.join_local()
