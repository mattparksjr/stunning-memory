extends Node

var network = NetworkedMultiplayerENet.new()
var gateway_api = MultiplayerAPI.new()

var ip = "127.0.0.1"
var port = 6971
var cert = load("res://resources/cert.crt")

var username
var password

func _process(delta):
	if get_custom_multiplayer() == null:
		return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()
	
func _connect(_username, _password):
	print("Got request to connect to gateway")
	network = NetworkedMultiplayerENet.new()
	gateway_api = MultiplayerAPI.new()
	
	# SSL
	network.set_dtls_enabled(true)
	network.set_dtls_verify_enabled(false) # TODO: Change on production launch
	network.set_dtls_certificate(cert)
	
	username = _username
	password = _password
	network.create_client(ip, port)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	network.connect("connection_failed", self, "on_connect_fail")
	network.connect("connection_succeeded", self, "on_connect_succeeded")

func on_connect_fail():
	print("Error: Connection failed")

func on_connect_succeeded():
	print("Connected to server")
	req_login()
	
func req_login():
	print("Connecting to gateway to request login")
	rpc_id(1, "login_request", username, password)
	username = ""
	password = ""

remote func return_login_request(result, token):
	if result == true:
		Server.token = token
		Server._connect()
	else:
		print("Auth failed")
	network.disconnect("connection_failed", self, "on_connect_fail")
	network.disconnect("connection_succeeded", self, "on_connect_succeeded")
