#########################################
# Name: PauseMenu
# Author: Matthew Parks
# Desc: Controls the display of the pause menu
#########################################
extends ColorRect

func _on_FPS_do_pause():
	set_visible(!visible)
	
func _ready():
	set_visible(false)
