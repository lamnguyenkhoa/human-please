extends Control
class_name ZoomView

@onready var zoom_container = $ZoomContainer

var previous_parent: Control
var previous_position: Vector2
var previous_scale: Vector2
var previous_document_area: Control

func _ready():
	visible = false
	GameManager.zoom_view = self
	previous_parent = null

func add_item_to_zoom(doc: MoveableDocument):
	previous_parent = doc.get_parent()
	previous_position = doc.position
	previous_scale = doc.scale
	previous_document_area = doc.document_area

	previous_parent.remove_child(doc)
	zoom_container.add_child(doc)
	doc.scale = Vector2(2, 2)
	var new_x = (get_viewport().get_visible_rect().size.x / 2) - doc.size.x
	var new_y = (get_viewport().get_visible_rect().size.y / 2) - doc.size.y
	doc.position = Vector2(new_x, new_y)
	doc.document_area = zoom_container

func return_item():
	var doc = zoom_container.get_child(0)
	var doc_parent = doc.get_parent()

	doc_parent.remove_child(doc)
	previous_parent.add_child(doc)
	doc.scale = previous_scale
	previous_parent = null
	doc.position = previous_position
	doc.document_area = previous_document_area