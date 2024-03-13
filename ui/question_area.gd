extends Control
class_name QuestionArea

var standard_btns: Array[Button]
var dialog_area: DialogArea

var standard_questions = [
	[
		"Please present your identification papers.",
		"Papers, please.",
		"I need to verify your identification.",
		"Where are your documents?"
	],
	[
		"What is your purpose of visit?",
		"Can you tell me why you visit this town?",
		"Please state your purpose of visit.",
		"Purpose of visit, please."
	]
]

func _ready():
	GameManager.subject_resolved.connect(_on_subject_resolved)
	GameManager.next_subject_readied.connect(_on_next_subject_readied)
	GameManager.question_area = self
	dialog_area = get_parent().get_node("DialogArea")
	standard_btns.append(get_node("TabContainer/Standard/VBoxContainer/Standard1"))
	standard_btns.append(get_node("TabContainer/Standard/VBoxContainer/Standard2"))
	standard_btns.append(get_node("TabContainer/Standard/VBoxContainer/Standard3"))
	standard_btns.append(get_node("TabContainer/Standard/VBoxContainer/Standard4"))
	standard_btns.append(get_node("TabContainer/Standard/VBoxContainer/Standard5"))
	_on_subject_resolved(false) # Disable buttons at the start of game

func _on_subject_resolved(_passed: bool):
	for btn in standard_btns:
		btn.disabled = true

func _on_next_subject_readied():
	for btn in standard_btns:
		btn.disabled = false

func _on_standard_2_pressed() -> void:
	dialog_area.add_inspector_dialog(select_random_string(standard_questions[1]))
	await get_tree().create_timer(1).timeout
	dialog_area.add_subject_dialog(GameManager.current_subject.dialogs[0].purpose_of_visit)
	standard_btns[1].disabled = true

func _on_standard_1_pressed() -> void:
	dialog_area.add_inspector_dialog(select_random_string(standard_questions[0]))
	await get_tree().create_timer(1).timeout
	dialog_area.add_subject_dialog(GameManager.current_subject.dialogs[0].identity_verification)
	standard_btns[0].disabled = true
	if not GameManager.current_subject.auto_give_passport:
		GameManager.working_area.spawn_passport()

func select_random_string(array):
	if array.size() == 0:
		return ""
	var randomIndex = randi() % array.size()
	return array[randomIndex]
