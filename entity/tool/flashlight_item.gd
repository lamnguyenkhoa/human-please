extends DrawerItem

@export var flashlight_prefab: PackedScene

@onready var texture_rect: TextureRect = $TextureRect

var turned_on = false
var flashlight_instance = null

func _on_button_pressed():
    SoundManager.play_ui_button_click_sfx()
    turned_on = !turned_on
    if turned_on:
        if flashlight_instance == null:
            flashlight_instance = flashlight_prefab.instantiate()
            GameManager.work_day.add_child(flashlight_instance)
        else:
            flashlight_instance.visible = true
        texture_rect.self_modulate.a = 0.5
    else:
        if flashlight_instance != null:
            flashlight_instance.visible = false
            texture_rect.self_modulate.a = 1



func _on_button_mouse_entered():
    SoundManager.play_button_hover_sfx()

