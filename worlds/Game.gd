extends Spatial


onready var player_spawn = $Playerspawn

# Called when the node enters the scene tree for the first time.
func _ready():
	var player1 = preload("res://prefabs/FPS.tscn").instance()
	player1.set_name(str(get_tree().get_network_unique_id()))
	player1.set_network_master(get_tree().get_network_unique_id())
	player1.global_transform = player_spawn.global_transform
	add_child(player1)
	
	var player2 = preload("res://prefabs/FPS.tscn").instance()
	player2.set_name(str(Globals.player2id))
	player2.set_network_master(Globals.player2id)
	player2.global_transform = player_spawn.global_transform
	add_child(player2)
