extends Node

var network = NetworkedMultiplayerENet.new()
var port = 6969
var max_players = 8

onready var player_verify = get_node("PlayerVerification")

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

remote func fetch_stats():
	print(LogFormatter.format("Handling request to get player stats"))
	var player_id = get_tree().get_rpc_sender_id()
	var stats = get_node(str(player_id)).player_name
	rpc_id(player_id, "return_stats", stats)
