extends Node

signal kill

func _on_Area_body_entered(body):
	print("Area entered")
	emit_signal("kill")
