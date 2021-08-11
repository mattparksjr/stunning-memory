extends Node

onready var player_container = preload("res://PlayerContainer.tscn")

func start(player_id):
	# TODO: Token auth
	create_player_container(player_id)

func create_player_container(player_id):
	var new_container = player_container.instance()
	new_container.name = str(player_id)
	get_parent().add_child(new_container, true)
	var player_container = get_node("../" + str(player_id))
	fill_container(player_container)
	
func fill_container(player_container):
	player_container.player_name = ServerData.test_name
