extends Node

var network = NetworkedMultiplayerENet.new()
var ip = "127.0.0.1"
var port = 6969
var token = ""
var client_clock = 0
var latency = 0
var latency_array = []
var delta_latency = 0
var decimal_coll : float = 0

func _physics_process(delta):
	client_clock += int(delta*1000) + delta_latency
	delta_latency = 0
	decimal_coll += (delta*1000) - int(delta * 1000)
	if decimal_coll >= 1.00:
		client_clock += 1
		decimal_coll -= 1.00
	
func _connect():
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	
	network.connect("connection_failed", self, "on_connect_fail")
	network.connect("connection_succeeded", self, "on_connect_succeeded")

func on_connect_fail():
	print("Error: Connection failed")

func on_connect_succeeded():
	print("Connected to server")
	rpc_id(1, "fetch_time", OS.get_system_time_msecs())
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.autostart = true
	timer.connect("timeout", self, "calc_latency")
	self.add_child(timer)
	
remote func recieve_time(server_time, client_time):
	latency = (OS.get_system_time_msecs() - client_time) / 2
	client_clock = server_time + latency

func calc_latency():
	rpc_id(1, "calc_latency", OS.get_system_time_msecs())

remote func return_latency(client_time):
	latency_array.append((OS.get_system_time_msecs() - client_time) / 2)
	if latency_array.size() == 9:
		var total_latency = 0
		latency_array.sort()
		var midpoint = latency_array[4]
		# Extreme packet discrimination
		for i in range(latency_array.size() -1, -1, -1):
			if latency_array[i] > (2 * midpoint) and latency_array[i] > 20:
				latency_array.remove(i)
			else:
				total_latency += latency_array[i]
		delta_latency = (total_latency / latency_array.size()) - latency
		latency = total_latency / latency_array.size()
		print("Latency: ", latency)
		print("Delta Latency: ", delta_latency)
		latency_array.clear()
	
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
