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
var setting_menu: SettingMenu

var current_subject: CharacterResource = null
var subject_count = 0
var decision_blocker = 0 # If this > 0, you can't press Allow or Deny
var illegal_allowed = 0
var legal_denied = 0
var is_in_zoom_view = false
var zoomed_doc: Control

# Save-able data
var owned_tokens = 0
var violation_left = 3

func _ready():
	SoundManager.set_master_volume(1)
	SoundManager.set_music_volume(0.8)
	SoundManager.set_sound_volume(0.8)
	return

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
		working_area.spawn_documents(current_subject)
	else:
		emit_signal("end_day")
		result_screen.show_result()

func calculate_pax_legal():
	if current_subject.passport_expired or \
	current_subject.bad_visit_reason or \
	current_subject.has_passport == EnumAutoload.HasPassport.DONT_HAVE or \
	current_subject.has_visit_card == EnumAutoload.HasVisitCard.DONT_HAVE or \
	current_subject.mismatch_visit_card_id:
		print(current_subject.name + " is ILLEGAL")
		return false
	print(current_subject.name + " is LEGAL")
	return true

func zoom_document(doc: MoveableDocument):
	is_in_zoom_view = true
	zoom_view.visible = true
	zoom_view.add_item_to_zoom(doc)
	zoomed_doc = doc
	if work_day.screen_light != null:
		work_day.screen_light.visible = false

func unzoom_document():
	is_in_zoom_view = false
	zoom_view.visible = false
	zoom_view.return_item()
	zoomed_doc = null
	if work_day.screen_light != null and work_day.dark_overlay != null:
		# Only show screen light if it's dark
		work_day.screen_light.visible = work_day.dark_overlay.visible

func open_setting_menu():
	setting_menu.open()
