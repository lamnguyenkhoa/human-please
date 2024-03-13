extends Node2D

@export var day0_scene: PackedScene

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(day0_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
