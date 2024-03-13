extends Control
class_name DialogArea

@export var subject_dialog_prefab: PackedScene
@export var inspector_dialog_prefab: PackedScene

@onready var dialog_container = $ScrollContainer/VBoxContainer
@onready var scroll_container: ScrollContainer = $ScrollContainer

var stop_dialog = false

func _ready():
	GameManager.dialog_area = self
	GameManager.subject_resolved.connect(_on_subject_resolved)
	GameManager.next_subject_readied.connect(_on_next_subject_readied)
	clear_all_dialog()

func _on_subject_resolved(_allowed: bool):
	clear_all_dialog()
	stop_dialog = true

func _on_next_subject_readied():
	stop_dialog = false
	var dialog = get_dialog_data()
	for elem in dialog.openings:
		await get_tree().create_timer(1).timeout
		if stop_dialog:
			return
		add_subject_dialog(elem)

func get_dialog_data() -> DialogResource:
	for elem in GameManager.current_subject.dialogs:
		if elem.day == GameManager.work_day.day:
			return elem
		else:
			print("DIALOG_AREA: ERROR CANT FIND DIALOG OF DAY ", GameManager.work_day.day)
	return null

func clear_all_dialog():
	for child in dialog_container.get_children():
		child.queue_free()

func add_subject_dialog(text: String):
	var new_dialog: DialogEntry = subject_dialog_prefab.instantiate()
	dialog_container.add_child(new_dialog)
	new_dialog.update_text("SUBJECT: " + text)
	await get_tree().process_frame
	scroll_container.ensure_control_visible(new_dialog)

func add_inspector_dialog(text: String):
	var new_dialog: DialogEntry = inspector_dialog_prefab.instantiate()
	dialog_container.add_child(new_dialog)
	new_dialog.update_text("INSPECTOR: " + text)
	await get_tree().process_frame
	scroll_container.ensure_control_visible(new_dialog)