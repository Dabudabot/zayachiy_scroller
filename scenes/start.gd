extends Node

func _on_play_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_web_btn_pressed() -> void:
	OS.shell_open("https://www.zayachiyston.ru/?utm_source=offline&utm_medium=game&utm_campaign=banner")
