extends Node2D
class_name WorkDay

@export var day: int
@export var date_string: String
@export var today_subjects: Array[CharacterResource]

func _ready():
	GameManager.work_day = self
	var game_ui = get_node("GameUI")
	game_ui.size.x = get_viewport().get_visible_rect().size.x
	game_ui.size.y = get_viewport().get_visible_rect().size.y
	get_node("GameUI/CameraArea").date_label.text = date_string
