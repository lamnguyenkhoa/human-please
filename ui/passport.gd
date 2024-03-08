extends Control

var is_dragging = false
var drag_offset = Vector2()
var mouse_in = false
var working_area: Control

func _ready():
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

func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false
