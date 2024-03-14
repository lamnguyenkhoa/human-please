extends MoveableDocument

@export_multiline var content: String

@onready var content_label: Label = $Background/Content
@onready var date_label: Label = $Background/Date

func _ready() -> void:
	super()
	content_label.text = content
	await get_tree().process_frame
	await get_tree().process_frame
	date_label.text = GameManager.work_day.date_string

func _process(delta):
	super(delta)
