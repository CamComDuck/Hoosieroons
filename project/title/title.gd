extends Node2D

func _on_button_pressed() -> void:
	AudioController.play_button()
	get_tree().change_scene_to_packed(load("res://level/level.tscn"))
