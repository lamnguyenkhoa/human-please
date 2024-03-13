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
var subject_count = 0
var decision_blocker = 0 # If this > 0, you can't press Allow or Deny

func allow_subject():
	emit_signal("subject_resolved", true)
	await get_tree().create_timer(2).timeout
	load_next_character()

func deny_subject():
	emit_signal("subject_resolved", false)
	await get_tree().create_timer(2).timeout
	load_next_character()

func start_work():
	camera_area.first_subject_transition()
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
