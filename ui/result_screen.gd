extends Control
class_name ResultScreen

@onready var background: Control = $Background
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var title: Label = $Title
@onready var stat: RichTextLabel = $Stat
@onready var rating: Label = $Rating
@onready var rating2: Label = $Rating2
@onready var next_day_button = $NextDay

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