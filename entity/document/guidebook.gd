extends MoveableDocument
class_name Guidebook

@export var rule3_text: Label
@export var rule4_text: Label

func _ready() -> void:
	super()
	await get_tree().process_frame
	await get_tree().process_frame
	var day = GameManager.work_day.day
	rule3_text.visible = false
	rule4_text.visible = false
	if day >= 3:
		rule3_text.visible = true
