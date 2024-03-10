extends Control

var dialog_area: DialogArea

var standard_1_questions = [
    "Please present your identification papers.",
    "Papers, please.",
    "I need to verify your identification.",
    "Where are your documents?"
]

var standard_2_questions = [
    "What is your purpose of visit?",
    "Can you tell me why you visit this town?",
    "Please state your purpose of visit.",
    "Purpose of visit, please."
]

func _ready():
    dialog_area = get_parent().get_node("DialogArea")

func _on_standard_2_pressed() -> void:
    dialog_area.add_inspector_dialog(select_random_string(standard_2_questions))
    dialog_area.add_subject_dialog(GameManager.current_subject.dialogs[0].purpose_of_visit)

func _on_standard_1_pressed() -> void:
    dialog_area.add_inspector_dialog(select_random_string(standard_1_questions))
    dialog_area.add_subject_dialog(GameManager.current_subject.dialogs[0].identity_verification)


func select_random_string(array):
    if array.size() == 0:
        return ""
    var randomIndex = randi() % array.size()
    return array[randomIndex]