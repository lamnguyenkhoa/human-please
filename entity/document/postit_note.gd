extends MoveableDocument

@export_multiline var content: String

@onready var content_label: Label = $TabContainer/Background/Content

func _ready() -> void:
	super()
	content_label.text = content