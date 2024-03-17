extends Node

signal subject_resolved(allowed)
signal next_subject_readied
signal end_day

var work_day: WorkDay
var working_area: WorkingArea
var camera_area: CameraArea
var dialog_area: DialogArea
var question_area: QuestionArea
var result_screen: ResultScreen
var zoom_view: ZoomView

var current_subject: CharacterResource = null
var subject_count = 0
var decision_blocker = 0 # If this > 0, you can't press Allow or Deny
var illegal_allowed = 0
var legal_denied = 0
var is_in_zoom_view = false
var zoomed_doc: Control

func start_work():
	# Reset some stats
	illegal_allowed = 0
	legal_denied = 0
	subject_count = 0
	decision_blocker = 0
	camera_area.first_subject_transition()
	await get_tree().create_timer(2).timeout
	load_next_character()

func allow_subject():
	if not calculate_pax_legal():
		illegal_allowed += 1
	emit_signal("subject_resolved", true)
	await get_tree().create_timer(2).timeout
	load_next_character()

func deny_subject():
	if calculate_pax_legal():
		legal_denied += 1
	emit_signal("subject_resolved", false)
	await get_tree().create_timer(2).timeout
	load_next_character()

func load_next_character():
	if work_day == null or working_area == null:
		return

	if subject_count < len(work_day.today_subjects):
		current_subject = work_day.today_subjects[subject_count]
		subject_count += 1
		emit_signal("next_subject_readied")
		if current_subject.auto_give_passport:
			working_area.spawn_passport()
	else:
		emit_signal("end_day")
		result_screen.show_result()

func calculate_pax_legal():
	if current_subject.passport_expired:
		return false
	if current_subject.bad_visit_reason:
		return false
	return true

func zoom_document(doc: MoveableDocument):
	is_in_zoom_view = true
	zoom_view.visible = true
	zoom_view.add_item_to_zoom(doc)
	zoomed_doc = doc

func unzoom_document():
	is_in_zoom_view = false
	zoom_view.visible = false
	zoom_view.return_item()
	zoomed_doc = null
