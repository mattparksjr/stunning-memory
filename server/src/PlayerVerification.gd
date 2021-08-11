extends Node

onready var server = get_parent()
onready var player_container = preload("res://PlayerContainer.tscn")
var await_verify = {}

func start(player_id):
	await_verify[player_id] = {"Timestamp": OS.get_unix_time()}
	server.fetch_token(player_id)

func create_player_container(player_id):
	var new_container = player_container.instance()
	new_container.name = str(player_id)
	get_parent().add_child(new_container, true)
	var player_container = get_node("../" + str(player_id))
	fill_container(player_container)

func verify(player_id, token):
	var verified = false
	while OS.get_unix_time() - int(token.right(64)) <= 30:
		if server.tokens.has(token):
			verified = true
			create_player_container(player_id)
			await_verify.erase(player_id)
			server.tokens.erase(token)
			break
		else:
			# Give client 30s to verify the provided token, incase of 
			# packet drop
			yield(get_tree().create_timer(2), "timeout")
	server.return_verify_result(player_id, verified)
	# Disconnect if no invalid token(incase a client tries to stay after
	# token failure
	if verified == false:
		await_verify.erase(player_id)
		server.network.disconnect_peer(player_id)
		
func fill_container(player_container):
	player_container.player_name = ServerData.test_name

# checks if someone has lost connection, and has sat in the 
# verification waiting room for a long time, and disconnects
# if so
func _on_VerificationExpire_timeout():
	var c_time = OS.get_unix_time()
	var start_time
	if await_verify == {}:
		pass
	else:
		for key in await_verify.keys():
			start_time = await_verify[key].Timestamp
			if c_time - start_time >=30:
				await_verify.erase(key)
				var connected = Array(get_tree().get_network_connected_peers())
				if connected.has(key):
					server.return_verify_result(key, false)
					server.network.disconnect_peer(key)
