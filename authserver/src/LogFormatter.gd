###########################
# Name: LogFormatter
# Author: Matthew
# Desc: Adds time stamps
#       to logs, for easier
#       debugging
###########################
extends Node

func format(message):
	var time = OS.get_time()
	var time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)
	return "[" + time_return + "] " + message
