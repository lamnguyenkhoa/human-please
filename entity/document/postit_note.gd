@tool
extends MoveableDocument

@export_multiline var content: String

@onready var content_label: Label = $TabContainer/Background/Content

func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
	content_label.text = content