extends Node

var network = NetworkedMultiplayerENet.new()
var port = 6969
var max_players = 8

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server has started")
	
	network.connect("peer_connected", self, "peer_connected")
	network.connect("peer_disconnected", self, "peer_disconnected")
	
func peer_connected(player_id):
	print("User " + str(player_id) + " has connected")

func peer_disconnected(player_id):
	print("User " + str(player_id) + " has disconnected")
