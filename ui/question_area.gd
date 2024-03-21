extends Control
class_name QuestionArea

var standard_btns: Array[Button]
var suspicious_btns: Array[Button]
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
	],
	[
		"How long you planned to stay here?",
		"How long will be this visit?",
		"Please state your duration of stay.",
	],
	[
		"What is your current inventory?",
		"What did you bring with you?",
		"Please list all of your item in possession.",
	],
	[
		"Have you visited this town before?",
		"Have you ever been here before?",
		"Is this your first time here?",
		"Please state your previous visits to this town.",
	]
]

var suspicious_questions = [
	[
		"What is your full name?",
		"Please tell me your full name.",
		"Your full name, please."
	],
	[
		"Your appearance doesn't look right to me.",
		"You look suspicious.",
		"Your appearance raise questions."
	]
]

func _ready():
	GameManager.subject_resolved.connect(_on_subject_resolved)
	GameManager.next_subject_readied.connect(_on_next_subject_readied)
	GameManager.question_area = self
	dialog_area = get_parent().get_node("DialogArea")
	for child: Button in get_node("TabContainer/Standard/VBoxContainer").get_children():
		standard_btns.append(child)
		child.mouse_entered.connect(button_hover_sfx)
	for child: Button in get_node("TabContainer/Suspicious/VBoxContainer").get_children():
		suspicious_btns.append(child)
		child.mouse_entered.connect(button_hover_sfx)
	_on_subject_resolved(false) # Disable buttons at the start of game

func _on_subject_resolved(_passed: bool):
	for btn in standard_btns:
		btn.disabled = true
	for btn in suspicious_btns:
		btn.disabled = true

func _on_next_subject_readied():
	for btn in standard_btns:
		btn.disabled = false
	for btn in suspicious_btns:
		btn.disabled = false

func select_random_string(array):
	if array.size() == 0:
		return ""
	var randomIndex = randi() % array.size()
	return array[randomIndex]

func print_dialog(question: String, answer: String, btn: Button):
	button_click_sfx()
	btn.disabled = true
	dialog_area.add_inspector_dialog(question)
	await get_tree().create_timer(1).timeout
	dialog_area.add_subject_dialog(answer)

func _on_standard_1_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(standard_questions[0]),
		current_dialog.identity_verification, standard_btns[0])
	if not GameManager.current_subject.auto_give_passport:
		GameManager.working_area.spawn_passport()

func _on_standard_2_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(standard_questions[1]),
		current_dialog.purpose_of_visit, standard_btns[1])

func _on_standard_3_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(standard_questions[2]),
		current_dialog.duration_of_stay, standard_btns[2])

func _on_standard_4_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(standard_questions[3]),
		current_dialog.item_in_possession, standard_btns[3])

func _on_standard_5_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(standard_questions[4]),
		current_dialog.previous_visit, standard_btns[4])

func _on_suspicious_1_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(suspicious_questions[0]),
		current_dialog.what_your_name, suspicious_btns[0])

func _on_suspicious_2_pressed() -> void:
	var current_dialog = Utils.get_dialog_data()
	print_dialog(select_random_string(suspicious_questions[1]),
		current_dialog.why_appearance, suspicious_btns[1])

func button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func button_click_sfx():
	SoundManager.play_radio_beep_sfx()

func _on_tab_container_tab_clicked(_tab: int) -> void:
	SoundManager.play_ui_button_click_sfx()

func _on_tab_container_tab_hovered(_tab: int) -> void:
	button_hover_sfx()
