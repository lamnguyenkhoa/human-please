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
@export var passport_expired: bool
@export var auto_give_passport: bool
@export var forgot_passport: bool
@export var bad_visit_reason: bool

# Day 3 onward
@export_group("Visit card")
@export var has_visit_card: EnumAutoload.HasVisitCard
@export var bad_visit_card: bool
@export var mismatch_visit_card_id: bool
@export var stay_location: String
@export var stay_duration: String

@export_group("")
@export var dialog: DialogResource

var gave_passport = false
var gave_visit_card = false
