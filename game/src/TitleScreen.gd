#########################################
# Name: Title Screen
# Author: Matthew Parks
# Desc: All of the code for the title screen
#########################################
extends ColorRect

onready var status_text = get_node("MultiplayerPopup/StatusText")

func on_single_press():
	get_parent().load_single()
	get_parent().remove_child(self)

func on_exit_press():
	get_tree().quit()

func on_multiplayer_press():
	get_node("PopupBlur").set_visible(true)
	get_node("MultiplayerPopup").popup()


func hide_blur():
	get_node("PopupBlur").set_visible(false)


func on_connect_press():
	if get_node("MultiplayerPopup/ServerIP").get_text() == "":
		status_text.bbcode_text = ""
		status_text.append_bbcode("[color=red]Please enter a server ip.[/color]")
	elif get_node("MultiplayerPopup/ServerPort").get_text() == "":
		status_text.bbcode_text = ""
		status_text.append_bbcode("[color=red]Please enter a server port.[/color]")
	else:
		status_text.bbcode_text = ""
		status_text.append_bbcode("[color=white]Connecting to gateway...[/color]")
		Gateway._connect("username", "password")
