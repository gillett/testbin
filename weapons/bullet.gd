
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"
var rocket_gun_class = preload("res://rocket_gun.gd")
var bp = preload("res://effects/fire_explosion.gd")
var STATE_FIRED = 1
var STATE_DYING = 0
var anim = ""
var obj_state = STATE_FIRED

var death_pos = Vector2(0,0)

func _die():
	queue_free()

func _integrate_forces(state):
	var new_anim = anim
	if obj_state == STATE_FIRED:
		for i in range(state.get_contact_count()):
			var cc = state.get_contact_collider_object(i)
			var dp = state.get_contact_local_normal(i)
			if cc:
				state=STATE_DYING
				new_anim = "die"
				
	elif obj_state == STATE_DYING:		
		get_node("anim").play("die")
	
	if( anim!=new_anim ):
		anim=new_anim
		get_node("anim").play(anim)

func _ready():
	# Initialization here
	var children = get_parent().get_children()
	for node in children:
		if (node.get_name() == 'bullet'):
			PS2D.body_add_collision_exception(node.get_rid(),get_rid()) # make bullet and this not collide			
	pass


