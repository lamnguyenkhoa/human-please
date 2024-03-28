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
    content_label.text = content_label.text.format([data.name, data.id_number, data.stay_location, data.stay_duration])

