#########################################
# Name: PlayerController
# Author: Matthew Parks
# Desc: Movement related code for the player
#########################################

extends KinematicBody

export var speed = 14
export var gravity = 75

var velocity = Vector3.ZERO
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(true)
	
func mouse(event):
	# This pisses me off, can we get some support for if(paused): pass
	if(paused):
		pass
	
func _input(event):
	if(event is InputEventKey):
		if(Input.is_action_pressed("pause")):
			paused = !paused
			if(paused):
				show_mouse()
			else:
				hide_mouse()
	if event is InputEventMouseMotion:
		return mouse(event)
	
func _physics_process(delta):
	var direction = Vector3.ZERO
		
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.look_at(translation + direction, Vector3.UP)
		
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	# Vertical velocity
	velocity.y -= gravity * delta
	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP)

################ Mouse visibly helpers ################
func hide_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
################# Mouse helpers ################
func _enter_tree():
	hide_mouse()
	
func _leave_tree():
	show_mouse()
