extends TabContainer
class_name MoveableDocument

@onready var timer: Timer = $DestroyTimer

@export var multiple_pages = false

var is_dragging = false
var drag_offset = Vector2()
var mouse_in = false
var document_area: Control
var belong_to_subject = false

func _ready():
	modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	if get_parent() != null and get_parent() is Control:
		document_area = get_parent()

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.get_button_index() == MOUSE_BUTTON_LEFT:
			if mouse_in:
				is_dragging = true
				drag_offset = get_global_mouse_position() - position
				show_document_on_top()
		elif not event.pressed and is_dragging:
			is_dragging = false

func _process(_delta):
	if is_dragging:
		var new_pos = get_global_mouse_position() - drag_offset
		keep_inside_document_area(new_pos)
	else:
		size = Vector2(0, 0) # Keep document size at minimum

func return_to_subject():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5).set_trans(Tween.TRANS_SINE)
	timer.start()
	
func _on_mouse_entered() -> void:
	mouse_in = true

func _on_mouse_exited() -> void:
	mouse_in = false

func _on_destroy_timer_timeout():
	queue_free()

func keep_inside_document_area(new_pos: Vector2):
	if document_area != null:
		var document_area_rect = document_area.get_rect()
		new_pos.x = clamp(new_pos.x, 0, document_area_rect.size.x - size.x)
		new_pos.y = clamp(new_pos.y, 0, document_area_rect.size.y - size.y)

	position = new_pos

func show_document_on_top():
	# Ensure the node has a parent
	if not get_parent():
		return
	# Move the node to the bottom of its parent's children, which will show the
	# document on top of others
	get_parent().move_child(self, get_parent().get_child_count() - 1)
	
func _on_next_page_button_pressed() -> void:
	var max_tabs = get_child_count()
	current_tab = clampi(current_tab + 1, 0, max_tabs - 1)

func _on_previous_page_button_pressed() -> void:
	var max_tabs = get_child_count()
	current_tab = clampi(current_tab - 1, 0, max_tabs - 1)

func _on_resized() -> void:
	keep_inside_document_area(position)
