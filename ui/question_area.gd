extends Control

var dialog_area: DialogArea

func _ready():
	dialog_area = get_parent().get_node("DialogArea")

func _on_standard_2_pressed() -> void:
	dialog_area.add_inspector_dialog("What is your purpose of visit?")
	dialog_area.add_subject_dialog(GameManager.current_subject.dialogs[0].purpose_of_visit)

func _on_standard_1_pressed() -> void:
	dialog_area.add_inspector_dialog("Please present your identification papers")
	dialog_area.add_subject_dialog(GameManager.current_subject.dialogs[0].identity_verification)