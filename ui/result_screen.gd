extends Control
class_name ResultScreen

@onready var background: Control = $Background
@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var title: Label = $Title
@onready var stat: RichTextLabel = $Stat
@onready var rating: Label = $Rating
@onready var rating2: Label = $Rating2
@onready var next_day_button = $EndDay
@onready var reward_label: Label = $Reward

var beep_sfx = preload ("res://asset/sfx/beep_1_33776__jobro.ogg")
var reward_amount = 0

func _ready():
	GameManager.result_screen = self
	visible = false
	background.visible = false
	title.visible = false
	stat.visible = false
	rating.visible = false
	rating2.visible = false
	next_day_button.visible = false
	reward_label.visible = false

func show_result():
	visible = true
	reward_amount = 0
	stat.text = stat.text.format([GameManager.subject_count, GameManager.legal_denied, GameManager.illegal_allowed])
	var correct_count = GameManager.subject_count - (GameManager.legal_denied + GameManager.illegal_allowed)
	var accuracy = float(correct_count) / GameManager.subject_count
	if accuracy == 1:
		rating2.self_modulate = Color.GREEN
		rating2.text = 'Excellent'
		add_reward(correct_count)
	elif accuracy > 0.5:
		rating2.self_modulate = Color.YELLOW
		rating2.text = 'Acceptable'
		add_reward(correct_count)
	else:
		rating2.self_modulate = Color.RED
		rating2.text = 'Unacceptable'
	anim_player.play("show_result")

func add_reward(correct):
	# Reward is 1 per correct choice, but only given if has above acceptable rating
	reward_amount = clampi(correct, 0, 1000)
	reward_label.text = reward_label.text.format([reward_amount])
	GameManager.owned_tokens += reward_amount

func show_reward_text():
	if GameManager.work_day.day == 0:
		return
	if reward_amount > 0:
		reward_label.visible = true

func _on_end_day_pressed() -> void:
	button_click_sfx()
	if GameManager.work_day.postwork_cutscene != null:
		visible = false
		GameManager.work_day.start_post_work_cutscene()
	else:
		move_to_next_day()

func move_to_next_day():
	if GameManager.work_day.next_day_scene != null:
		visible = false
		get_tree().change_scene_to_packed(GameManager.work_day.next_day_scene)
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