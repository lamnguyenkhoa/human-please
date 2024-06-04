extends Control
class_name MoveableDocument

@onready var timer: Timer = $DestroyTimer
@onready var tab_container = $TabContainer

var page_flip_buttons: Array[PageFlipButton] = []
var is_dragging = false
var drag_offset = Vector2(0, 0)
var mouse_in = false
var document_area: Control
var belong_to_subject = false
var picked_up_pos = Vector2(0, 0)

var document_moving_sfx = preload ("res://asset/sfx/document_moving_261086__jaklocke.ogg")
var flip_paper_sfx = preload ("res://asset/sfx/flip_paper_391350__vithormoraes.ogg")
var inspect_document_sfx = preload ("res://asset/sfx/inspect_document_509878__slamaxur.ogg")
var receive_remove_new_doc_sfx = preload ("res://asset/sfx/receive_subject_doc_46625__123jorre456__.ogg")

func _ready():
	modulate = Color(1, 1, 1, 0)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.5).set_trans(Tween.TRANS_SINE)
	for page in tab_container.get_children():
		for elem in page.get_children():
			if elem is PageFlipButton:
				page_flip_buttons.append(elem)

func _input(event):
	if event.is_action_pressed("right_click"):
		if GameManager.is_in_zoom_view and GameManager.zoomed_doc == self:
			GameManager.unzoom_document()
			play_sfx(document_moving_sfx)
		elif not GameManager.is_in_zoom_view and mouse_in:
			GameManager.zoom_document(self)
			play_sfx(inspect_document_sfx)

	if event is InputEventMouseButton:
		if event.pressed and event.get_button_index() == MOUSE_BUTTON_LEFT:
			if mouse_in:
				is_dragging = true
				drag_offset = get_global_mouse_position() - position
				picked_up_pos = position
				show_document_on_top()
				if not GameManager.is_in_zoom_view:
					play_sfx(document_moving_sfx)
		elif not event.pressed and is_dragging:
			is_dragging = false
			if not GameManager.is_in_zoom_view:
				play_sfx(document_moving_sfx)

func _process(_delta):
	if is_dragging:
		var new_pos = get_global_mouse_position() - drag_offset
		if GameManager.is_in_zoom_view:
			position = new_pos
		else:
			keep_inside_document_area(new_pos)
		if position != picked_up_pos and not GameManager.is_in_zoom_view:
			tab_container.position = Vector2( - 8, -8)
	else:
		tab_container.size = Vector2(0, 0) # Keep document size at minimum
		size = tab_container.size
		tab_container.position = Vector2(0, 0)

func return_to_subject():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.5).set_trans(Tween.TRANS_SINE)
	timer.start()

func _on_mouse_entered() -> void:
	mouse_in = true
	for elem in page_flip_buttons:
		elem.visible = true

func _on_mouse_exited() -> void:
	mouse_in = false
	for elem in page_flip_buttons:
		elem.visible = false

func _on_destroy_timer_timeout():
	play_sfx(receive_remove_new_doc_sfx)
	queue_free()

func keep_inside_document_area(new_pos: Vector2):
	if document_area != null:
		var document_area_rect = document_area.get_rect()
		new_pos.x = clamp(new_pos.x, 0, document_area_rect.size.x - (size.x * scale.x))
		new_pos.y = clamp(new_pos.y, 0, document_area_rect.size.y - (size.y * scale.y))
	position = new_pos

func show_document_on_top():
	# Ensure the node has a parent
	if not get_parent():
		return
	# Move the node to the bottom of its parent's children, which will show the
	# document on top of others
	get_parent().move_child(self, get_parent().get_child_count() - 1)

func _on_next_page_button_pressed() -> void:
	var max_tabs = tab_container.get_tab_count()
	tab_container.current_tab = clampi(tab_container.current_tab + 1, 0, max_tabs - 1)
	play_sfx(flip_paper_sfx)

func _on_previous_page_button_pressed() -> void:
	var max_tabs = tab_container.get_tab_count()
	tab_container.current_tab = clampi(tab_container.current_tab - 1, 0, max_tabs - 1)
	play_sfx(flip_paper_sfx)

func _on_resized() -> void:
	keep_inside_document_area(position)

func _on_rule_button_pressed() -> void:
	tab_container.current_tab = 2

func _on_term_button_pressed() -> void:
	tab_container.current_tab = 4

func _on_local_map_button_pressed() -> void:
	tab_container.current_tab = 5

func play_sfx(sfx: AudioStream):
	var audio_stream_player = AudioStreamPlayer2D.new()
	add_child(audio_stream_player)
	audio_stream_player.connect("finished", func(): audio_stream_player.queue_free())
	audio_stream_player.bus = "SFX"
	audio_stream_player.stream = sfx
	audio_stream_player.pitch_scale = randf_range(0.8, 1.2)
	audio_stream_player.play()
