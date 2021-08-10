extends Node

var map_start = preload("res://worlds/World.tscn")

func _ready():
	print("Loading map")
	var mapstart_ins = map_start.instance()
	add_child(mapstart_ins)
