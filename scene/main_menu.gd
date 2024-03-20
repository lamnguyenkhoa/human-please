extends Node2D

@export var day0_scene: PackedScene

func _on_start_button_pressed() -> void:
	button_click_sfx()
	get_tree().change_scene_to_packed(day0_scene)

func _on_quit_button_pressed() -> void:
	button_click_sfx()
	get_tree().quit()

func button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func button_click_sfx():
	SoundManager.play_ui_button_click_sfx()