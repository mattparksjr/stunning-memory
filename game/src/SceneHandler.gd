extends Node

var map_start = preload("res://worlds/World.tscn")
var title_screen = preload("res://ui/TitleScreen.tscn")

func _ready():
	print("Loading UI")
	var title_screen_ins = title_screen.instance()
	add_child(title_screen_ins)
	#print("Loading map")
	#var mapstart_ins = map_start.instance()
	#add_child(mapstart_ins)

func load_single():
	print("Loading map")
	var mapstart_ins = map_start.instance()
	add_child(mapstart_ins)
