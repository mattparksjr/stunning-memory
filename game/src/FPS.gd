#########################################
# Name: PlayerController
# Author: Matthew Parks
# Desc: New and most likey the best fps
#       controller.
#########################################
extends KinematicBody

export var speed = 7
export var sprint_speed_multi = 1.5

# These could be constants butttt export more fun :)
export var ACCEL_DEFAULT = 7
export var ACCEL_AIR = 1

onready var accel = ACCEL_DEFAULT
export var gravity = 9.8
export var jump = 4.5

export var cam_accel = 40
export var mouse_sense = 0.1
var snap
var paused = false

var direction = Vector3()
var velocity = Vector3()
var gravity_vec = Vector3()
var movement = Vector3()

signal do_pause
signal kill

onready var head = $Head
onready var camera = $Head/Camera
onready var spawn = get_parent().get_node("PlayerSpawn")

func _ready():
	set_process_input(true)
	
func _input(event):
	if event is InputEventMouseMotion:
		if not paused:
			# Rotates the head of the player based on mouse pos, and mouse sens
			rotate_y(deg2rad(-event.relative.x * mouse_sense))
			head.rotate_x(deg2rad(-event.relative.y * mouse_sense))
			head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
	if event is InputEventKey:
		# Keybinds, and pause menu
		if(Input.is_action_pressed("pause")):
			paused = !paused
			emit_signal("do_pause")
		# No in-line :( sad days
		if(paused):
			show_mouse()
		else:
			hide_mouse()
		# TODO: DEBUG ONLY
		if Input.is_key_pressed(KEY_KP_4):
			print("DEBUG KEY PRESSED")
			Gateway._connect("username", "password")
		if Input.is_key_pressed(KEY_KP_5):
			print("DEBUG KEY PRESSED")
			Game.tmp_do()

func _process(delta):
	# camera physics interpolation to reduce physics jitter on high refresh-rate monitors (like matts)
	if Engine.get_frames_per_second() > Engine.iterations_per_second:
		camera.set_as_toplevel(true)
		camera.global_transform.origin = camera.global_transform.origin.linear_interpolate(head.global_transform.origin, cam_accel * delta)
		camera.rotation.y = rotation.y
		camera.rotation.x = head.rotation.x
	else:
		camera.set_as_toplevel(false)
		camera.global_transform = head.global_transform
		
func _physics_process(delta):
	if not paused:
		direction = Vector3.ZERO
	
		# input values
		var h_rot = global_transform.basis.get_euler().y
		var f_input = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
		var h_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
		direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
		if is_on_floor():
			snap = -get_floor_normal()
			accel = ACCEL_DEFAULT
			gravity_vec = Vector3.ZERO
		else:
			snap = Vector3.DOWN
			accel = ACCEL_AIR
			gravity_vec += Vector3.DOWN * gravity * delta
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			snap = Vector3.ZERO
			gravity_vec = Vector3.UP * jump
	
		# make it move
		if(Input.is_action_pressed("sprint")):
			velocity = velocity.linear_interpolate(direction * speed * sprint_speed_multi, accel * delta)
			movement = velocity + gravity_vec
		else:
			velocity = velocity.linear_interpolate(direction * speed, accel * delta)
			movement = velocity + gravity_vec
	
		move_and_slide_with_snap(movement, snap, Vector3.UP)
	
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

################ RESPAWN TMP DEBUG ##############

func _on_DeathArea_kill():
	print("should be teleporting")
	transform.origin = spawn.transform.origin
