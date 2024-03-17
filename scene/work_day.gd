extends Node2D
class_name WorkDay

@export var day: int
@export var date_string: String
@export var today_subjects: Array[CharacterResource]

func _ready():
	GameManager.work_day = self
	var game_ui = get_node("GameUI")
	game_ui.size.x = ProjectSettings.get_setting("display/window/size/viewport_width")
	game_ui.size.y = ProjectSettings.get_setting("display/window/size/viewport_height")
	get_node("GameUI/CameraArea").date_label.text = date_string
