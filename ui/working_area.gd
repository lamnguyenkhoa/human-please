extends Control
class_name WorkingArea

@export var usa_passport_prefab: PackedScene
@export var today_extra_documents: Array[MoveableDocument]

@onready var document_area = $DocumentArea
@onready var document_spawn = $DocumentArea/DocumentSpawn

func _ready():
	GameManager.working_area = self
	GameManager.subject_resolved.connect(_on_subject_resolved)
	for doc in today_extra_documents:
		var doc_parent = doc.get_parent()
		doc_parent.remove_child(doc)
		document_area.add_child(doc)
		doc.visible = true
	for doc in document_area.get_children():
		if doc is MoveableDocument:
			doc.document_area = document_area

func _on_subject_resolved(_allowed: bool):
	remove_subject_document()

func remove_subject_document():
	for elem in document_area.get_children():
		if elem is MoveableDocument:
			var doc = elem as MoveableDocument
			if doc.belong_to_subject:
				doc.return_to_subject()

func spawn_passport():
	var new_pp = usa_passport_prefab.instantiate() as Passport
	document_area.add_child(new_pp)
	new_pp.document_area = document_area
	new_pp.belong_to_subject = true
	new_pp.position = document_spawn.position
	new_pp.position.x -= (new_pp.size.x / 2)
	new_pp.character_data = GameManager.current_subject
	new_pp.populate_passport_data()
