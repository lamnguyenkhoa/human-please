extends Control

func _on_allow_button_pressed() -> void:
	GameManager.allow_subject()

func _on_deny_button_pressed() -> void:
	GameManager.deny_subject()
