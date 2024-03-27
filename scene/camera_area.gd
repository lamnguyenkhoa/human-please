extends Control
class_name CameraArea

@onready var transition_cover = $TransitionCover
@onready var result_label: Label = $TransitionCover/Result
@onready var notify_label: Label = $TransitionCover/Notify
@onready var subject: TextureRect = $Camera/Mask/ZoomArea/Subject
@onready var subject_too_close: TextureRect = $Camera/Mask/ZoomArea/SubjectTooClose
@onready var zoom_area = $Camera/Mask/ZoomArea
@onready var zoom_amount_label: Label = $Camera/ZoomAmount
@onready var camera_control_group = $ControlPanel/CameraControl
@onready var allow_button: Button = $ControlPanel/Allowed
@onready var deny_button: Button = $ControlPanel/Denied
@onready var start_work_button: Button = $ControlPanel/StartWork
@onready var date_label: Label = $Camera/Date

@onready var wood_step_sfx: AudioStreamPlayer2D = $WoodStepSFX
@onready var open_door_sfx: AudioStreamPlayer2D = $OpenDoorSFX
@onready var door_bell_sfx: AudioStreamPlayer2D = $DoorBellSFX

@onready var start_work_sfx = preload ("res://asset/sfx/door_bell_digital_571674__nachtmahrtv.ogg")

var max_v_distance = 0
var max_h_distance = 0

const BASE_MOVE_DISTANCE = 32

func _ready():
	connect_to_game_manager()
	transition_cover.visible = false
	notify_label.visible = false
	change_zoom_value(false)
	update_button_status(true)

func connect_to_game_manager():
	GameManager.camera_area = self
	GameManager.subject_resolved.connect(_on_subject_resolve)
	GameManager.next_subject_readied.connect(_on_next_subject_readied)
	
func _on_subject_resolve(allowed: bool):
	transition_effect(allowed)
	update_button_status(true)

func _on_next_subject_readied():
	change_zoom_value(false)
	change_zoom_value(false)
	update_button_status(false)
	update_subject_on_camera()
	start_work_button.visible = false
	transition_cover.visible = false
	notify_label.visible = false

func update_subject_on_camera():
	subject.texture = null
	subject_too_close.texture = null
	if GameManager.current_subject.stand_too_close:
		subject_too_close.texture = GameManager.current_subject.sprite
		subject_too_close.visible = true
	else:
		subject.texture = GameManager.current_subject.sprite
		subject.visible = true

func first_subject_transition():
	play_transition_sfx()
	result_label.text = "Work started"
	transition_cover.visible = true
	await get_tree().create_timer(1).timeout
	notify_label.text = "Subject entered"
	notify_label.visible = true

func transition_effect(allowed: bool):
	play_transition_sfx()
	if allowed:
		result_label.text = "Subject passed"
	else:
		result_label.text = "Subject denied"
	transition_cover.visible = true
	subject.visible = false
	subject_too_close.visible = false
	await get_tree().create_timer(1).timeout
	# If there are no more subjects
	if GameManager.subject_count >= len(GameManager.work_day.today_subjects):
		notify_label.text = "Work finished"
	else:
		notify_label.text = "Next subject entered"
	notify_label.visible = true

func update_button_status(no_subject_now: bool):
	for elem in camera_control_group.get_children():
		elem.disabled = no_subject_now
	allow_button.disabled = no_subject_now
	deny_button.disabled = no_subject_now

func change_zoom_value(zoom_in: bool):
	var val = zoom_area.scale.x
	if zoom_in:
		val = clamp(val * 2, 1, 4)
	else:
		val = clamp(val / 2, 1, 4)
	zoom_area.scale = Vector2(val, val)
	max_h_distance = zoom_area.pivot_offset.x * (zoom_area.scale.x - 1)
	max_v_distance = zoom_area.pivot_offset.y * (zoom_area.scale.y - 1)
	zoom_area.position.x = clamp(zoom_area.position.x, -max_v_distance, max_v_distance)
	zoom_area.position.y = clamp(zoom_area.position.y, -max_h_distance, max_h_distance)
	zoom_amount_label.text = "X" + str(val)

func play_transition_sfx():
	wood_step_sfx.pitch_scale = randf_range(0.8, 1.2)
	open_door_sfx.pitch_scale = randf_range(0.8, 1.2)
	door_bell_sfx.pitch_scale = randf_range(0.9, 1.1)
	wood_step_sfx.play()
	open_door_sfx.play()
	await get_tree().create_timer(1).timeout
	door_bell_sfx.play()

func request_subject_stand_further():
	subject_too_close.texture = null
	subject.texture = GameManager.current_subject.sprite
	subject.visible = true

func _on_zoom_in_pressed() -> void:
	button_click_sfx()
	change_zoom_value(true)

func _on_zoom_out_pressed() -> void:
	button_click_sfx()
	change_zoom_value(false)

func _on_up_pressed() -> void:
	button_click_sfx()
	var new_val = zoom_area.position.y + BASE_MOVE_DISTANCE * (zoom_area.scale.y - 1)
	zoom_area.position.y = clamp(new_val, -max_h_distance, max_h_distance)

func _on_left_pressed() -> void:
	button_click_sfx()
	var new_val = zoom_area.position.x + BASE_MOVE_DISTANCE * (zoom_area.scale.x - 1)
	zoom_area.position.x = clamp(new_val, -max_v_distance, max_v_distance)

func _on_down_pressed() -> void:
	button_click_sfx()
	var new_val = zoom_area.position.y - BASE_MOVE_DISTANCE * (zoom_area.scale.y - 1)
	zoom_area.position.y = clamp(new_val, -max_h_distance, max_h_distance)

func _on_right_pressed() -> void:
	button_click_sfx()
	var new_val = zoom_area.position.x - BASE_MOVE_DISTANCE * (zoom_area.scale.x - 1)
	zoom_area.position.x = clamp(new_val, -max_v_distance, max_v_distance)

func _on_denied_pressed() -> void:
	button_click_sfx()
	GameManager.deny_subject()

func _on_allowed_pressed() -> void:
	button_click_sfx()
	GameManager.allow_subject()

func _on_start_work_pressed() -> void:
	SoundManager.play_sound(start_work_sfx, "SFX")
	button_click_sfx()
	GameManager.start_work()

func button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func button_click_sfx():
	SoundManager.play_ui_button_click_sfx()

func _on_setting_pressed() -> void:
	button_click_sfx()
	GameManager.open_setting_menu()
