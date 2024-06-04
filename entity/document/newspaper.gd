@tool
extends MoveableDocument

@export var title1_content: String
@export var title2_content: String

@onready var title1_label: Label = $TabContainer/Open/Title1
@onready var title2_label: Label = $TabContainer/Open/Title2
@onready var date_label1: Label = $TabContainer/Folded/Date
@onready var date_label2: Label = $TabContainer/Open/Date

func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
		await get_tree().process_frame
		await get_tree().process_frame
		date_label1.text = GameManager.work_day.date_string
		date_label2.text = GameManager.work_day.date_string
	title1_label.text = title1_content
	title2_label.text = title2_content
