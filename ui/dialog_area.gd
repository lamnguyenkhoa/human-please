extends Control
class_name DialogArea

@export var subject_dialog_prefab: PackedScene
@export var inspector_dialog_prefab: PackedScene

@onready var dialog_container = $ScrollContainer/VBoxContainer

func _ready():
	clear_all_dialog()

func clear_all_dialog():
	for child in dialog_container.get_children():
		child.queue_free()

func add_subject_dialog(text: String):
	var new_dialog: DialogEntry = subject_dialog_prefab.instantiate()
	dialog_container.add_child(new_dialog)
	new_dialog.update_text("SUBJECT: " + text)

func add_inspector_dialog(text: String):
	var new_dialog: DialogEntry = inspector_dialog_prefab.instantiate()
	dialog_container.add_child(new_dialog)
	new_dialog.update_text("INSPECTOR: " + text)
