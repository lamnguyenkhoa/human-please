extends Node2D

@onready var transition_cover = $TransitionCover
@onready var result_label: Label = $TransitionCover/Result
@onready var notify_label: Label = $TransitionCover/Notify

@onready var subject: Sprite2D = $Subject
@onready var shadow: Sprite2D = $Shadow
@onready var face: Sprite2D = $Face

func _ready():
	transition_cover.visible = false
	notify_label.visible = false
	GameManager.subject_passed.connect(subject_passed)
	GameManager.subject_denied.connect(subject_denied)

func subject_passed():
	result_label.text = "Subject passed"
	common_transition_effect()

func subject_denied():
	result_label.text = "Subject denied"
	common_transition_effect()

func common_transition_effect():
	transition_cover.visible = true
	face.visible = false
	subject.visible = false
	shadow.visible = false
	await get_tree().create_timer(1).timeout
	notify_label.visible = true
	await get_tree().create_timer(1).timeout
	transition_cover.visible = false
	notify_label.visible = false