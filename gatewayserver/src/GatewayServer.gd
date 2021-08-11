extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var port = 6971
var max_players = 4

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
	
	print(LogFormatter.format("Gateway server started"))
	network.connect("peer_connected", self, "peer_connected")
	network.connect("peer_disconnected", self, "peer_disconnected")
	
func peer_connected(player_id):
	print(LogFormatter.format("User " + str(player_id) + " has connected"))

func peer_disconnected(player_id):
	print(LogFormatter.format("User " + str(player_id) + " has disconnected"))

remote func login_request(username, password):
	print(LogFormatter.format("Got login request"))
	var player_id = custom_multiplayer.get_rpc_sender_id()
	Authenticate.auth_player(username, password, player_id)

func return_login_request(result, player_id):
	rpc_id(player_id, "return_login_request", result)
	network.disconnect_peer(player_id)
