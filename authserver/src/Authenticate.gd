extends Node

var network = NetworkedMultiplayerENet.new()
var port = 8076
var max_servers = 4

func _ready():
	start_server()
	
func start_server():
	network.create_server(port, max_servers)
	get_tree().set_network_peer(network)
	print(LogFormatter.format("Auth server started"))
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")

func _peer_connected(gateway_id):
	print(LogFormatter.format("Gateway " + str(gateway_id) + " connected"))
	
func _peer_disconnected(gateway_id):
	print(LogFormatter.format("Gateway " + str(gateway_id) + " disconnected"))
	
remote func auth_player(username, password, player_id):
	print(LogFormatter.format("Got auth request"))
	var gateway_id = get_tree().get_rpc_sender_id()
	var result
	var token
	
	if username != "username":
		result = false
	elif password != "password":
		result = false
	else:
		print(LogFormatter.format("Correct auth recieved"))
		result = true
		
		randomize()
		var random_n = randi()
		var hashed = str(random_n).sha256_text()
		print(LogFormatter.format("Hash: " + hashed))
		var timestamp = str(OS.get_unix_time())
		print(LogFormatter.format(timestamp))
		token = hashed + timestamp
		print(LogFormatter.format(token))
		# TODO load balancing
		var game_server = "game_sever1"
		GameServers.distribute_token(token, game_server)
		
	print(LogFormatter.format("Sending auth result to gateway"))
	rpc_id(gateway_id, "auth_result", result, player_id, token)
