extends KinematicBody2D

func _ready():
	print("Loaded kinematic body")
	set_collide_with_rigid_bodies(true)
	set_process(true)

func _process(delta):
	if is_colliding():
		print("Collision")