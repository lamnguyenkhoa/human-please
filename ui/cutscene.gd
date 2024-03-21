extends Control

@onready var tab_container: TabContainer = $TabContainer
@onready var timer: Timer = $Timer
@onready var foreground_cover = $ForegroundCover
@onready var anim_player = $AnimationPlayer

var cutscene_ended = false

func _ready():
	tab_container.current_tab = 0
	foreground_cover.visible = true
	timer.start(1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('left_click'):
		if cutscene_ended or !timer.is_stopped():
			return
		var max_tab = tab_container.get_tab_count() - 1
		SoundManager.play_ui_button_click_sfx()
		if tab_container.current_tab + 1 > max_tab:
			GameManager.work_day.start_day_after_cutscene(self)
			cutscene_ended = true
		else:
			tab_container.current_tab += 1
		timer.start(0.5)

func start_cutscene():
	visible = true
	anim_player.play("fadeout")