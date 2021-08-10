extends Node2D


func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")


func _on_Button_Host_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(6969, 2)
	get_tree().set_network_peer(net)
	print("Hosting on 6969")

func _on_Button_Join_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_client("127.0.0.1", 6969)
	get_tree().set_network_peer(net)
	print("Joining on 6969")
	
func _player_connected(id):
	Globals.player2id = id
	var game = preload("res://worlds/World.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()
