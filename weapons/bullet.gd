
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var STATE_DIE = 0

func _die():
	print("shitkill")
	queue_free()

func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var cc = state.get_contact_collider_object(i)
		var dp = state.get_contact_local_normal(i)
		if cc:
			STATE_DIE = 1

	if STATE_DIE == 1:		
		get_node("anim").play("die")
			

func _ready():
	# Initialization here
	pass


