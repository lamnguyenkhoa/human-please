@tool
extends MoveableDocument

@export_multiline var content: String

@onready var content_label: Label = $TabContainer/Background/Content
@onready var date_label: Label = $TabContainer/Background/Date

func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
		await get_tree().process_frame
		await get_tree().process_frame
		date_label.text = "Issued date: " + GameManager.work_day.date_string
	content_label.text = content
