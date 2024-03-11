extends Node

signal subject_passed
signal subject_denied

@export var subject_today: Array[CharacterResource]

var current_subject: CharacterResource
var today: String = "12/04/2000"

func _ready() -> void:
	current_subject = subject_today[0]

func allow_subject():
	emit_signal("subject_passed")

func deny_subject():
	emit_signal("subject_denied")
