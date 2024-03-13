extends Node2D
class_name WorkDay

@export var day_number: int
@export var date: String
@export var today_subjects: Array[CharacterResource]

func _ready():
    GameManager.work_day = self