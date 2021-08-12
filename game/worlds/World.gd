extends Node

var player_to_spawn = preload("res://prefabs/NetworkedPlayer.tscn")

func spawn_player(player_id):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		var new_player = player_to_spawn.instance()
		new_player.global_transform.origin = get_node("PlayerSpawn").global_transform.origin
		new_player.name = str(player_id)
		get_node("NetworkedPlayers").add_child(new_player)
		
func despawn_player(player_id):
	get_node("NetworkedPlayers" + str(player_id)).queue_free()
