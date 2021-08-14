extends Node

var player_to_spawn = preload("res://prefabs/NetworkedPlayer.tscn")
var last_world_update = 0
var world_state_buffer = []
# Although this is exported, 100millis is industry standard
export var interpolation_offset = 100

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
	var new_player = player_to_spawn.instance()
	new_player.move(location)
	new_player.name = str(player_id)
	get_node("NetworkedPlayers").add_child(new_player)
		
func despawn_player(player_id):
	yield(get_tree().create_timer(0.2), "timeout")
	if get_node_or_null("NetworkedPlayers" + str(player_id)) != null:
		get_node("NetworkedPlayers" + str(player_id)).queue_free()

func _physics_process(delta):
	var render_time = OS.get_system_time_msecs() - interpolation_offset
	if world_state_buffer.size() > 1:
		while world_state_buffer.size() > 2 and render_time > world_state_buffer[2].T:
			world_state_buffer.remove(0)
			# this factor determines the time elapsed between renders, if the
			# buffer has newer data, we need to try and move the player closer
			# to that state
		if world_state_buffer.size() > 2:
			var interpolation_factor = float(render_time - world_state_buffer[1]["T"]) / float(world_state_buffer[2]["T"] - world_state_buffer[0]["T"])
			for player in world_state_buffer[2].keys():
				if str(player) == "T":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[1].has(player):
					continue
				if get_node("NetworkedPlayers").has_node(str(player)):
					var new_pos = lerp(world_state_buffer[1][player]["P"], world_state_buffer[2][player]["P"], interpolation_factor)
					get_node("NetworkedPlayers/" + 
						str(player)).move(new_pos)
				else:
					spawn_player_withloc(player, world_state_buffer[2][player]["P"])
		elif render_time > world_state_buffer[1].T:
			var extrapolation_factor = float(render_time - world_state_buffer[0]["T"]) / float(world_state_buffer[1]["T"] - world_state_buffer[0]["T"]) - 1.00
			for player in world_state_buffer[1].keys():
				if str(player) == "T":
					continue
				if player == get_tree().get_network_unique_id():
					continue
				if not world_state_buffer[0].has(player):
					continue
				if get_node("NetworkedPlayers").has_node(str(player)):
					var position_delta = (world_state_buffer[1][player]["P"] - world_state_buffer[0][player]["P"])
					var new_pos = world_state_buffer[1][player]["P"] + (position_delta * extrapolation_factor)
					get_node("NetworkedPlayers/" + 
						str(player)).move(new_pos)
func update_world_state(world_state):
	if world_state["T"] > last_world_update:
		last_world_update = world_state["T"]
		world_state_buffer.append(world_state)
