extends Node2D
class_name WorkDay

@export var day: int
@export var date_string: String
@export var today_subjects: Array[CharacterResource]

@export var has_cutscene = false
@export var cutscene_bgm: AudioStream

@onready var bgm: AudioStreamPlayer = $BGM

var default_bgm = preload ("res://asset/music/booth_ambient_440126__blaukreuz.ogg")

func _ready():
	GameManager.work_day = self
	var game_ui = get_node("GameUI")
	game_ui.size.x = get_viewport().get_visible_rect().size.x
	game_ui.size.y = get_viewport().get_visible_rect().size.y
	get_node("GameUI/CameraArea").date_label.text = date_string
	if has_cutscene:
		var cutscene = get_node("GameUI/Cutscene")
		cutscene.start_cutscene()
		if cutscene_bgm != null:
			bgm.stream = cutscene_bgm
			bgm.pitch_scale = 0.6
			bgm.play()
	else:
		bgm.stream = default_bgm
		bgm.play()

func start_day_after_cutscene(cutscene: Control):
	cutscene.visible = false
	bgm.stream = default_bgm
	bgm.play()
