extends HBoxContainer
class_name DialogEntry

@onready var label: Label = $Label

func update_text(text: String):
	label.text = text
