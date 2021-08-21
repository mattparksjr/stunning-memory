extends Node

var data_path = "user://data.json"

# Simple config stuff
var default_values = {
	"gateway-server-ip": "127.0.0.1",
	"gatway-server-port": "6971",
	"version": "0.0.1-DEV"
}

var data = {}

func _ready():
	load_data()

func load_data():
	var file = File.new()
	
	if not file.file_exists(data_path):
		print("Config does not exist. Creating...")
		reset_data()
		return
	
	print("Reading config...")
	file.open(data_path, file.READ)
	var txt = file.get_as_text()
	data = parse_json(txt)
	file.close()
	
func reset_data():
	data = default_values.duplicate(true)
	save_data()
	
func save_data():
	print("Saving config...")
	var file = File.new()
	file.open(data_path, File.WRITE)
	file.store_line(to_json(data))
	file.close()
	
func delete_data():
	var dir = Directory.new()
	dir.remove(data_path)
	reset_data()
	
 
