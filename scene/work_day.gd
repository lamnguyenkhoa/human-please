extends Node2D
class_name WorkDay

@export var day: int
@export var date_string: String
@export var today_subjects: Array[CharacterResource]

func _ready():
	GameManager.work_day = self
	get_node("CanvasLayer/GameUI/CameraArea").date_label.text = date_string