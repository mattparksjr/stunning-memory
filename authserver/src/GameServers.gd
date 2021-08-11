extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 1912
var max_players = 100

var game_server_list = {}

func _ready():
	start()
	
func _process(delta):
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func start():
	network.create_server(port, max_players)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	print(LogFormatter.format("GameServer hub has started"))
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	
func _peer_connected(gameserver_id):
	print(LogFormatter.format("Game server " + str(gameserver_id) + " connected"))
	game_server_list["game_sever1"] = gameserver_id
	print(LogFormatter.format("Game server list: " + str(game_server_list)))
	
func _peer_disconnected(gameserver_id):
	print(LogFormatter.format("Game server " + str(gameserver_id) + " disconnected"))

func distribute_token(token, game_server):
	var gameserver_pid = game_server_list[game_server]
	rpc_id(gameserver_pid, "recieve_token", token)
	
