extends Node

var player_to_spawn = preload("res://prefabs/NetworkedPlayer.tscn")
var last_world_update = 0

func spawn_player(player_id):
	if get_tree().get_network_unique_id() != player_id:
		if get_node("NetworkedPlayers").has_node(str(player_id)):
			return
		var new_player = player_to_spawn.instance()
		new_player.global_transform.origin = get_node("PlayerSpawn").global_transform.origin
		new_player.name = str(player_id)
		get_node("NetworkedPlayers").add_child(new_player)
		
func spawn_player_withloc(player_id, location):
	if get_tree().get_network_unique_id() == player_id:
		pass
	else:
		var new_player = player_to_spawn.instance()
		new_player.global_transform = location
		new_player.name = str(player_id)
		get_node("NetworkedPlayers").add_child(new_player)
		
func despawn_player(player_id):
	get_node("NetworkedPlayers" + str(player_id)).queue_free()

func update_world_state(world_state):
	# TODO: Buffer, interpolate, extrapolate, and rubber band
	if world_state["T"] > last_world_update:
		last_world_update = world_state["T"]
		world_state.erase("T") 
		world_state.erase(get_tree().get_network_unique_id())
		for player in world_state.keys():
			if get_node("NetworkedPlayers").has_node(str(player)):
				get_node("NetworkedPlayers/" + 
					str(player)).move(world_state[player]["P"])
			else:
				# TODO: SEND MSG ONCE ITS IMPL
				spawn_player_withloc(player, world_state[player]["P"])
