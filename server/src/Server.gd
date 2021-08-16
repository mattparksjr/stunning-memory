extends Node

var network = NetworkedMultiplayerENet.new()
var port = 6969
var max_players = 8

onready var player_verify = get_node("PlayerVerification")
var tokens = []
var player_states = {}

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print(LogFormatter.format("Server has started"))
	
	network.connect("peer_connected", self, "peer_connected")
	network.connect("peer_disconnected", self, "peer_disconnected")
	
func peer_connected(player_id):
	print(LogFormatter.format("User " + str(player_id) + " has connected"))
	player_verify.start(player_id)

func peer_disconnected(player_id):
	print(LogFormatter.format("User " + str(player_id) + " has disconnected"))
	if has_node(str(player_id)):
		get_node(str(player_id)).queue_free()
		player_states.erase(player_id)
		rpc_id(0, "despawn_player", player_id)

remote func fetch_time(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "recieve_time", OS.get_system_time_msecs(), client_time)
	
remote func calc_latency(client_time):
	var player_id = get_tree().get_rpc_sender_id()
	rpc_id(player_id, "return_latency", client_time)
	
func send_world_state(world_state):
	rpc_unreliable_id(0, "recieve_world_state", world_state)
	
remote func recieve_player_state(player_state):
	var player_id = get_tree().get_rpc_sender_id()
	# This check makes sure we dont update the state if we dont need to(got old packet after newer)
	if player_states.has(player_id):
		if(player_states[player_id]["T"] < player_state["T"]):
			player_states[player_id] = player_state
	else:
		player_states[player_id] = player_state

remote func fetch_stats():
	print(LogFormatter.format("Handling request to get player stats"))
	var player_id = get_tree().get_rpc_sender_id()
	var stats = get_node(str(player_id)).player_name
	rpc_id(player_id, "return_stats", stats)

func fetch_token(player_id):
	rpc_id(player_id, "get_token")

remote func return_token(token):
	var player_id = get_tree().get_rpc_sender_id()
	player_verify.verify(player_id, token)
	
func return_verify_result(player_id, result):
	rpc_id(player_id, "return_verify_result", result)
	if result == true:
		rpc_id(0, "spawn_player", player_id)
	
func _on_Timer_timeout():
	var current_time = OS.get_unix_time()
	var token_time
	if tokens == []:
		pass
	else:
		# traverse backwards to stop index shifting of deleted tokens
		for i in range(tokens.size() -1, -1, -1):
			token_time = int(tokens[i].right(64))
			if current_time - token_time >= 30:
				tokens.remove(i)
