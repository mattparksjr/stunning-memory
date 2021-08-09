extends Sprite

func _ready():
	position.x = OS.get_window_safe_area().size.x / 2
	position.y = OS.get_window_safe_area().size.y / 2
