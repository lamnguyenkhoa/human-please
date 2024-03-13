extends Node

signal subject_resolved(allowed)
signal next_subject_readied
signal end_day

var work_day: WorkDay
var working_area: WorkingArea
var camera_area: CameraArea
var dialog_area: DialogArea
var question_area: QuestionArea

var current_subject: CharacterResource = null
var subject_count: int = 0

func allow_subject():
	emit_signal("subject_resolved", true)

func deny_subject():
	emit_signal("subject_resolved", false)

func ready_next_subject():
	load_next_character()
	await get_tree().process_frame

func load_next_character():
	if work_day == null or working_area == null:
		return

	if subject_count == 0:
		camera_area.first_subject_transition()

	if subject_count < len(work_day.today_subjects):
		current_subject = work_day.today_subjects[subject_count]
		subject_count += 1
		emit_signal("next_subject_readied")
		working_area.spawn_passport()
	else:
		emit_signal("end_day")