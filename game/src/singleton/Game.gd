extends Spatial
	
func tmp_do():
	Server.fetch_stats()
	
func load_stats(stats):
	print(stats + Server.token)
