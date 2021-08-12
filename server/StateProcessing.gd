extends Node

var world_state = {}

func _physics_process(delta):
	if get_parent().player_states.empty():
		return
	world_state = get_parent().player_states.duplicate(true)
	for player in world_state.keys():
		world_state[player].erase("T")
	world_state["T"] = OS.get_system_time_msecs()
	# TODO: Any verifications, anti-cheat etc
	get_parent().send_world_state(world_state)
