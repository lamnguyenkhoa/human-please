@tool
extends MoveableDocument

@onready var content_label: Label = $TabContainer/Background/Content
@onready var date_label: Label = $TabContainer/Background/Date

func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
		await get_tree().process_frame
		await get_tree().process_frame
		date_label.text = GameManager.work_day.date_string

func populate_data(data: CharacterResource):
	var template = "Esteemed Inspector,\n
	You are hereby directed to grant passage to the individual identified as [{0}] through the checkpoint.\n
	This individual possesses official authorization for entry as granted by the government."
	content_label.text = template.format([data.name])