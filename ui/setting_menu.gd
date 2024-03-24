extends Control
class_name SettingMenu

@onready var master_slider: HSlider = $TabContainer/Audio/Master/MasterSlider
@onready var bgm_slider: HSlider = $TabContainer/Audio/BGM/BGMSlider
@onready var sfx_slider: HSlider = $TabContainer/Audio/SFX/SFXSlider

var is_starting_up = true

func _ready() -> void:
	visible = false
	GameManager.setting_menu = self
	master_slider.value = SoundManager.get_master_volume() * 100
	bgm_slider.value = SoundManager.get_music_volume() * 100
	sfx_slider.value = SoundManager.get_sound_volume() * 100
	is_starting_up = false

func open():
	visible = true

func button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func button_click_sfx():
	SoundManager.play_ui_button_click_sfx()

func _on_back_button_pressed() -> void:
	button_click_sfx()
	visible = false

func _on_master_slider_value_changed(value: float) -> void:
	if not is_starting_up:
		button_click_sfx()
	SoundManager.set_master_volume(value / 100)

func _on_sfx_slider_value_changed(value: float) -> void:
	if not is_starting_up:
		button_click_sfx()
	SoundManager.set_sound_volume(value / 100)

func _on_bgm_slider_value_changed(value: float) -> void:
	if not is_starting_up:
		button_click_sfx()
	SoundManager.set_music_volume(value / 100)

