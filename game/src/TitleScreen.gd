#########################################
# Name: Title Screen
# Author: Matthew Parks
# Desc: All of the code for the title screen
#########################################
extends ColorRect

func on_single_press():
	get_parent().load_single()
	get_parent().remove_child(self)

func on_exit_press():
	get_tree().quit()

func on_multiplayer_press():
	pass # Replace with function body.
