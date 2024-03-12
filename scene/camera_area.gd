extends Control

@onready var transition_cover = $TransitionCover
@onready var result_label: Label = $TransitionCover/Result
@onready var notify_label: Label = $TransitionCover/Notify
@onready var subject: TextureRect = $Camera/Mask/ZoomArea/Subject
@onready var zoom_area = $Camera/Mask/ZoomArea
@onready var zoom_amount_label: Label = $Camera/ZoomAmount

var max_v_distance = 0
var max_h_distance = 0

const BASE_MOVE_DISTANCE = 32

func _ready():
	transition_cover.visible = false
	notify_label.visible = false
	GameManager.subject_passed.connect(subject_passed)
	GameManager.subject_denied.connect(subject_denied)
	change_zoom_value(false)

func subject_passed():
	result_label.text = "Subject passed"
	common_transition_effect()

func subject_denied():
	result_label.text = "Subject denied"
	common_transition_effect()

func common_transition_effect():
	transition_cover.visible = true
	subject.visible = false
	await get_tree().create_timer(1).timeout
	notify_label.visible = true
	await get_tree().create_timer(1).timeout
	transition_cover.visible = false
	notify_label.visible = false

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

func _on_zoom_in_pressed() -> void:
	change_zoom_value(true)

func _on_zoom_out_pressed() -> void:
	change_zoom_value(false)

func _on_up_pressed() -> void:
	var new_val = zoom_area.position.y + BASE_MOVE_DISTANCE * (zoom_area.scale.y - 1)
	zoom_area.position.y = clamp(new_val, -max_h_distance, max_h_distance)

func _on_left_pressed() -> void:
	var new_val = zoom_area.position.x + BASE_MOVE_DISTANCE * (zoom_area.scale.x - 1)
	zoom_area.position.x = clamp(new_val, -max_v_distance, max_v_distance)

func _on_down_pressed() -> void:
	var new_val = zoom_area.position.y - BASE_MOVE_DISTANCE * (zoom_area.scale.y - 1)
	zoom_area.position.y = clamp(new_val, -max_h_distance, max_h_distance)

func _on_right_pressed() -> void:
	var new_val = zoom_area.position.x - BASE_MOVE_DISTANCE * (zoom_area.scale.x - 1)
	zoom_area.position.x = clamp(new_val, -max_v_distance, max_v_distance)
