extends Node2D
class_name WorkDay

@export var day: int
@export var date_string: String
@export var today_subjects: Array[CharacterResource]
@export var shuffle_subjects_order = true
@export var next_day_scene: PackedScene

@export var prework_cutscene: Cutscene
@export var postwork_cutscene: Cutscene

@export var lightout_after_n_second: int = -1

@onready var bgm: AudioStreamPlayer = $BGM
@onready var day_announcer = $GameUI/DayAnnouncer
@onready var camera_area: CameraArea = $GameUI/CameraArea

var default_bgm = preload ("res://asset/music/booth_ambient_440126__blaukreuz.ogg")
var open_door_sfx = preload ("res://asset/sfx/door_open_15419__pagancow.ogg")
var new_day_sfx = preload ("res://asset/sfx/jingle_105228__chimerical.ogg")
var power_cut_sfx = preload ("res://asset/sfx/power_cut_400194__ninjatrappeur.ogg")

var screen_light: PointLight2D
var dark_overlay: CanvasModulate
var lightout_timer: Timer

func _ready():
	GameManager.work_day = self
	var game_ui = get_node("GameUI")
	game_ui.size.x = get_viewport().get_visible_rect().size.x
	game_ui.size.y = get_viewport().get_visible_rect().size.y
	camera_area.date_label.text = date_string
	if shuffle_subjects_order:
		today_subjects.shuffle()
	if day == 0:
		day_announcer.get_node("Label").text = "Training day\n\n{0}".format([date_string])
	else:
		day_announcer.get_node("Label").text = "Day {0}\n\n{1}".format([day, date_string])
	day_announcer.visible = true
	if prework_cutscene != null:
		start_cutscene(prework_cutscene)
	else:
		start_workday()

	if lightout_after_n_second >= 0:
		start_timer_lightout()

func start_cutscene(cutscene: Cutscene):
	cutscene.start_cutscene()
	if cutscene.cutscene_bgm != null:
		bgm.stream = cutscene.cutscene_bgm
		bgm.pitch_scale = 0.6
		bgm.play()
	else:
		bgm.stop()

func start_workday():
	bgm.stream = default_bgm
	bgm.play()
	day_announcer.visible = true
	SoundManager.play_sound(open_door_sfx, "SFX", true)
	SoundManager.play_sound(new_day_sfx, "SFX")
	await get_tree().create_timer(2).timeout
	day_announcer.visible = false

func start_post_work_cutscene():
	if postwork_cutscene != null:
		start_cutscene(postwork_cutscene)

func start_timer_lightout():
	screen_light = get_node("ScreenLight")
	dark_overlay = get_node("DarkOverlay")
	lightout_timer = get_node("LightoutTimer")
	screen_light.visible = false
	dark_overlay.visible = false
	lightout_timer.start(lightout_after_n_second)
	lightout_timer.timeout.connect(lightout)

func lightout():
	SoundManager.play_sound(power_cut_sfx, "SFX", true)
	bgm.stop()
	dark_overlay.visible = true
	if not GameManager.is_in_zoom_view:
		screen_light.visible = true
