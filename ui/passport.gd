extends Control

var is_dragging = false
var drag_offset = Vector2()
var mouse_in = false
var working_area: Control

@onready var timer: Timer = $DestroyTimer

func _ready():
    modulate = Color(1, 1, 1, 0)
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
    if get_parent() != null and get_parent() is Control:
        working_area = get_parent()

func _input(event):
    if event is InputEventMouseButton:
        if event.pressed and event.get_button_index() == MOUSE_BUTTON_LEFT:
            var mouse_pos = get_global_mouse_position()
            if mouse_in:
                is_dragging = true
                drag_offset = mouse_pos - position
        elif not event.pressed and is_dragging:
            is_dragging = false

func _process(_delta):
    if is_dragging:
        var new_pos = get_global_mouse_position() - drag_offset
        if working_area != null:
            var working_area_rect = working_area.get_rect()
            new_pos.x = clamp(new_pos.x, 0, working_area_rect.size.x - size.x)
            new_pos.y = clamp(new_pos.y, 0, working_area_rect.size.y - size.y)
        position = new_pos

func remove():
    var tween = get_tree().create_tween()
    tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5).set_trans(Tween.TRANS_SINE)
    timer.start()
    
func _on_mouse_entered() -> void:
    mouse_in = true

func _on_mouse_exited() -> void:
    mouse_in = false

func _on_destroy_timer_timeout():
    queue_free()
