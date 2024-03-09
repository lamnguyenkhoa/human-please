extends Node

@export var subject_today: Array[CharacterResource]

var current_subject: CharacterResource

func _ready() -> void:
    current_subject = subject_today[0]
