@tool
extends MoveableDocument

@export_multiline var new_rule: String

@onready var new_rule_label: Label = $TabContainer/Background/NewRule
@onready var date_label: Label = $TabContainer/Background/Date

func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
		await get_tree().process_frame
		await get_tree().process_frame
		date_label.text = GameManager.work_day.date_string
	new_rule_label.text = new_rule
