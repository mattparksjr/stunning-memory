extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 6969
var token = ""

func _ready():
	pass
	
func _connect():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "on_connect_fail")
	network.connect("connection_succeeded", self, "on_connect_succeeded")

func on_connect_fail():
	print("Error: Connection failed")

func on_connect_succeeded():
	print("Connected to server")

func fetch_stats():
	rpc_id(1, "fetch_stats")
	
func send_state(player_state):
	rpc_unreliable_id(1, "recieve_player_state", player_state)
	
remote func spawn_player(player_id):
	get_node("../SceneHandler/Map").spawn_player(player_id)
	
remote func despawn_player(player_id):
	get_node("../SceneHandler/Map").despawn_player(player_id)
	
remote func recieve_world_state(world_state):
	get_node("../SceneHandler/Map").update_world_state(world_state)
	
remote func return_verify_result(result):
	if result:
		print("Token verification was successful")
	else:
		print("Token verification failed")

remote func get_token():
	rpc_id(1, "return_token", token)
	
remote func return_stats(stats):
	get_node("/root/Game").load_stats(stats)
