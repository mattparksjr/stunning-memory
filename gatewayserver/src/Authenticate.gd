extends Node

var network = NetworkedMultiplayerENet.new()
var ip = ""
var port = 0

func _ready():
	_connect()

func _connect():
	print(LogFormatter.format("Connecting to the auth server...."))
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "on_connect_fail")
	network.connect("connection_succeeded", self, "on_connect_succeeded")

func on_connect_fail():
	print(LogFormatter.format("Error: Connection failed (auth server)"))

func on_connect_succeeded():
	print(LogFormatter.format("Connected to server (auth server)"))

remote func auth_player(username, password, player_id):
	print(LogFormatter.format("Sending auth request"))
	rpc_id(1, "auth_player", username, password, player_id)
	
remote func auth_result(result, player_id, token):
	print(LogFormatter.format("Got auth request result, relaying...."))
	GatewayServer.return_login_request(result, player_id, token)
