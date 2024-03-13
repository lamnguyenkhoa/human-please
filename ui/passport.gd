extends MoveableDocument
class_name Passport

@export var character_data: CharacterResource

@onready var basic_details: RichTextLabel = $Page/PersonalDetail
@onready var top_serial: Label = $Page/TopSerial
@onready var face_photo: TextureRect = $Page/Photo

func _ready() -> void:
	super()
	populate_passport_data()

func populate_passport_data():
	if character_data == null:
		return
	var gender = "M"
	if character_data.gender == EnumAutoload.Gender.FEMALE:
		gender = "F"
	var expired_date = random_generate_date(character_data.birthdate, character_data.passport_expired)
	basic_details.text = basic_details.text.format({"name": character_data.name, "dob": character_data.birthdate, "gender": gender, "expired_date": expired_date})
	top_serial.text = character_data.id_number
	face_photo.texture = character_data.face_photo

func random_generate_date(birthdate: String, expired: bool) -> String:
	# Create a random number generator
	var rng = RandomNumberGenerator.new()
	var day = rng.randi_range(1, 31)
	var month = rng.randi_range(1, 12)

	if month == 2:
		if day > 28:
			day = 28

	var date_parts = birthdate.split("/")
	var birthyear = int(date_parts[2])
	var year = rng.randi_range(birthyear + 18, 2050)
	if expired:
		year = rng.randi_range(birthyear + 18, 1999)

	var date_str = "%02d/%02d/%04d" % [day, month, year]

	return date_str