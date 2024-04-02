@tool
extends MoveableDocument
class_name VisitCard

@onready var content_label: Label = $TabContainer/Background/Content
@onready var date_label: Label = $TabContainer/Background/Date

var character_data: CharacterResource

func _ready() -> void:
	if not Engine.is_editor_hint():
		super()
		await get_tree().process_frame
		await get_tree().process_frame
		date_label.text = "Valid on " + GameManager.work_day.date_string

func populate_data(data: CharacterResource):
	if data == null:
		return
	var id_number = data.id_number
	if data.mismatch_visit_card_id:
		var number_part = Utils.get_number_part(id_number)
		id_number = "C" + str(Utils.generate_random_number(len(str(number_part)), number_part))
	content_label.text = content_label.text.format([data.name, id_number, data.stay_location, data.stay_duration])
