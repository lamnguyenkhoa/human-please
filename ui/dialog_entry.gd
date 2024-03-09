extends HBoxContainer
class_name DialogEntry

@export var label: Label

func update_text(text: String):
	label.text = text
