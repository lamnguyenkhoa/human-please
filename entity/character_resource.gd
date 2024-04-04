extends Resource
class_name CharacterResource

@export_group("Basic")
@export var name: String
@export var sprite: Texture2D
@export var face_photo: Texture2D
@export var gender: EnumAutoload.Gender
@export var birthdate: String
@export var nationality: String
@export var id_number: String
@export var stand_too_close: bool

@export var has_passport: EnumAutoload.HasPassport
@export var passport_expired: bool
@export var bad_visit_reason: bool

# Day 3 onward
@export_group("Visit card")
@export var has_visit_card: EnumAutoload.HasVisitCard
@export var mismatch_visit_card_id: bool
@export var wrong_visit_card_issued_date: bool
@export var stay_location: String
@export var stay_duration: String

@export_group("")
@export var dialog: DialogResource

@export_group("Extra documents")
@export var extra_id_doc: Array[PackedScene]
@export var extra_visit_purpose_doc: Array[PackedScene]

var gave_passport = false
var gave_visit_card = false
