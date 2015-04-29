
extends RigidBody2D

# member variables here, example:
# var a=2
# var b="textvar"

var rocket_pos = Vector2(0,0)
var direction

func _ready():
	#for i in get_parent().get_children():
		#print(i.get_name())
	#	if i.get_name() == "rocket":
	#		rocket_pos = i.get_global_pos()
	
	rocket_pos = get_parent().get_node("rocket").get_global_pos()
	var pos_diff = (get_global_pos() - rocket_pos)
	print(pos_diff.x)
	if 	pos_diff.x > 0:
		get_node("sprite").set_scale(Vector2(-1,1))
	if pos_diff.x < 0:
		get_node("sprite").set_scale(Vector2(1,1))
	pass


