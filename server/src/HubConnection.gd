extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()
var ip = ""
var port = 0

onready var gameserver = get_node("/root/Server")

func _ready():
	_connect()
	
func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func _connect():
	print(LogFormatter.format("Connecting to game server hub"))
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	network.connect("connection_failed", self, "_onconnectfail")
	network.connect("connection_succeeded", self, "_onconnectsucceed")

func _onconnectfail():
	print(LogFormatter.format("Failed to connect to the game server hub"))

func _onconnectsucceed():
	print(LogFormatter.format("Connected to the game server hub"))

remote func recieve_token(token):
	gameserver.tokens.append(token)
