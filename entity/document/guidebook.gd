extends MoveableDocument
class_name Guidebook

@export var rule3_text: Label
@export var rule4_text: Label

func _ready() -> void:
	super()
	await get_tree().process_frame
	await get_tree().process_frame
	var day = GameManager.work_day.day