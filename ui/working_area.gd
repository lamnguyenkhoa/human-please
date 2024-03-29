extends Control
class_name WorkingArea

@export var usa_passport_prefab: PackedScene
@export var visit_card_prefab: PackedScene

@export var today_extra_documents: Array[MoveableDocument]
@export var today_items: Array[DrawerItem]

@onready var document_area = $DocumentArea
@onready var document_spawn = $DocumentArea/DocumentSpawn
@onready var anim_player = $AnimationPlayer
@onready var item_area = $DrawerArea/Drawer1/ItemArea

var drawer_opened = false
var open_drawer_sfx = preload ("res://asset/sfx/open_drawer_550361__mattruthsound.ogg")

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
	for item in today_items:
		var global_pos = item.global_position
		var item_parent = item.get_parent()
		item_parent.remove_child(item)
		item_area.add_child(item)
		item.global_position = global_pos

func _on_subject_resolved(_allowed: bool):
	remove_subject_document()

func remove_subject_document():
	for elem in document_area.get_children():
		if elem is MoveableDocument:
			var doc = elem as MoveableDocument
			if doc.belong_to_subject:
				doc.return_to_subject()

func spawn_documents(data: CharacterResource):
	if data.auto_give_passport:
		spawn_passport()
	if data.auto_give_visit_card:
		spawn_visit_card()

func spawn_passport():
	if GameManager.current_subject.forgot_passport:
		return
	var new_pp = usa_passport_prefab.instantiate() as Passport
	document_area.add_child(new_pp)
	new_pp.document_area = document_area
	new_pp.belong_to_subject = true
	new_pp.position = document_spawn.position
	new_pp.position.x -= (new_pp.size.x / 2)
	new_pp.position.x += randf_range( - 10, 10)
	new_pp.position.y += randf_range( - 10, 10)
	new_pp.character_data = GameManager.current_subject
	new_pp.populate_passport_data()
	new_pp.play_sfx(new_pp.receive_remove_new_doc_sfx)

func spawn_visit_card():
	if GameManager.current_subject.no_visit_card:
		return
	var new_vc = visit_card_prefab.instantiate() as VisitCard
	document_area.add_child(new_vc)
	new_vc.document_area = document_area
	new_vc.belong_to_subject = true
	new_vc.position = document_spawn.position
	new_vc.position.x -= (new_vc.size.x / 2)
	new_vc.position.x += randf_range( - 10, 10)
	new_vc.position.y += randf_range( - 30, 30)
	new_vc.populate_data(GameManager.current_subject)
	new_vc.play_sfx(new_vc.receive_remove_new_doc_sfx)

func _on_open_close_drawer_button_pressed() -> void:
	button_click_sfx()
	SoundManager.play_sound(open_drawer_sfx, "SFX", true)
	if drawer_opened:
		anim_player.play("close_drawer")
	else:
		anim_player.play("open_drawer")
	drawer_opened = !drawer_opened

func button_hover_sfx():
	SoundManager.play_button_hover_sfx()

func button_click_sfx():
	SoundManager.play_ui_button_click_sfx()
