#########################################
# Name: Box
# Author: Matthew Parks
# Desc: Can be used to change mesh colors
#       while in the inspector
#########################################

extends Spatial

export var color = Color.gray

func _ready():
	var newMaterial = SpatialMaterial.new() 
	newMaterial.albedo_color = color 
	$"MeshInstance".material_override = newMaterial
