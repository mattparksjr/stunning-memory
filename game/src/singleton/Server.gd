extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 6969

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
	
remote func return_stats(stats):
	get_node("/root/Game").load_stats(stats)
