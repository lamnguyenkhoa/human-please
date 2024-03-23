extends Control
class_name ResultScreen

@export var next_day_scene: PackedScene

@onready var background: Control = $Background
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var title: Label = $Title
@onready var stat: RichTextLabel = $Stat
@onready var rating: Label = $Rating
@onready var rating2: Label = $Rating2
@onready var next_day_button = $EndDay

var beep_sfx = preload ("res://asset/sfx/beep_1_33776__jobro.ogg")

func _ready():
	GameManager.result_screen = self
	visible = false
	background.visible = false
	title.visible = false
	stat.visible = false
	rating.visible = false
	rating2.visible = false
	next_day_button.visible = false

func show_result():
	visible = true
	stat.text = stat.text.format([GameManager.subject_count, GameManager.legal_denied, GameManager.illegal_allowed])
	var correct_count = GameManager.subject_count - (GameManager.legal_denied + GameManager.illegal_allowed)
	var accuracy = float(correct_count) / GameManager.subject_count
	if accuracy == 1:
		rating2.self_modulate = Color.GREEN
		rating2.text = 'Excellent'
	elif accuracy >= 0.5:
		rating2.self_modulate = Color.YELLOW
		rating2.text = 'Acceptable'
	else:
		rating2.self_modulate = Color.RED
		rating2.text = 'Unacceptable'

	anim_player.play("show_result")

func _on_end_day_pressed() -> void:
	button_click_sfx()
	if GameManager.work_day.postwork_cutscene != null:
		GameManager.work_day.start_post_work_cutscene()
	else:
		move_to_next_day()

func move_to_next_day():
	if next_day_scene != null:
		get_tree().change_scene_to_packed(next_day_scene)
	else:
		next_day_button.text = "NEXT DAY STILL WIP.\nTHANKS FOR PLAYING"

func play_beep_sfx():
	SoundManager.play_sound(beep_sfx, "SFX", true)

func button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func button_click_sfx():
	SoundManager.play_ui_button_click_sfx()

func _on_end_day_mouse_entered():
	button_hover_sfx()