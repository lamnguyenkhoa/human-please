extends Node

signal subject_passed
signal subject_denied

@export var subject_today: Array[CharacterResource]

var current_subject: CharacterResource
var subject_count: int = 0
var today: String = "12/04/2000"

func _ready() -> void:
	load_next_character()

func allow_subject():
	emit_signal("subject_passed")

func deny_subject():
	emit_signal("subject_denied")

func load_next_character():
	current_subject = subject_today[0]
	subject_count += 1
