extends Button
class_name PageFlipButton

@export var flip_prev: bool

@onready var page_flip_icon: TextureRect = $PageFlipIcon

func _ready():
	visible = false
	if flip_prev:
		page_flip_icon.flip_h = true