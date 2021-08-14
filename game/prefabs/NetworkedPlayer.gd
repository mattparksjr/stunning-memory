extends KinematicBody

# This expects a Vec3
func move(new_pos):
	transform.origin = new_pos
