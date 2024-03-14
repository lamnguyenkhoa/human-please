extends Resource
class_name CharacterResource

@export var name: String
@export var sprite: Texture2D
@export var face_photo: Texture2D
@export var gender: EnumAutoload.Gender
@export var birthdate: String
@export var nationality: String
@export var id_number: String
@export var passport_expired: bool
@export var bad_visit_reason: bool
@export var auto_give_passport: bool
@export var dialog: DialogResource

var gave_id = false