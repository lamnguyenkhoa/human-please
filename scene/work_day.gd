extends Node2D
class_name WorkDay

@export var day: int
@export var date_string: String
@export var today_subjects: Array[CharacterResource]

@export var has_cutscene = false
@export var cutscene_bgm: AudioStream

@onready var bgm: AudioStreamPlayer = $BGM
@onready var day_announcer = $GameUI/DayAnnouncer
@onready var camera_area: CameraArea = $GameUI/CameraArea

var default_bgm = preload ("res://asset/music/booth_ambient_440126__blaukreuz.ogg")
var open_door_sfx = preload ("res://asset/sfx/door_open_15419__pagancow.ogg")
var door_bell_sfx = preload ("res://asset/sfx/door_bell_571674__nachtmahrtv.ogg")

func _ready():
	GameManager.work_day = self
	var game_ui = get_node("GameUI")
	game_ui.size.x = get_viewport().get_visible_rect().size.x
	game_ui.size.y = get_viewport().get_visible_rect().size.y
	camera_area.date_label.text = date_string
	if day == 0:
		day_announcer.get_node("Label").text = "Training day\n\n{0}".format([date_string])
	else:
		day_announcer.get_node("Label").text = "Day {0}\n\n{1}".format([day, date_string])
	day_announcer.visible = true
	if has_cutscene:
		var cutscene = get_node("GameUI/Cutscene")
		cutscene.start_cutscene()
		if cutscene_bgm != null:
			bgm.stream = cutscene_bgm
			bgm.pitch_scale = 0.6
			bgm.play()
	else:
		start_day_stuff()

func start_day_stuff():
	bgm.stream = default_bgm
	bgm.play()
	day_announcer.visible = true
	SoundManager.play_sound(open_door_sfx, "SFX", true)
	SoundManager.play_sound(door_bell_sfx, "SFX")
	await get_tree().create_timer(2).timeout
	day_announcer.visible = false
