extends Polygon2D

# member variables here, example:
# var a=2
# var b="textvar"

var STATE_LOCKED = 1
var STATE_OPEN = 0

var anim = ""
func _ready():
	# Initialization here
	#anim = "locked"
	#get_node("switch_anim").play(anim)
	pass

func _on_Area2D_body_enter( body ):

	var new_anim = anim
	if body.get_name() == "rocket":
		if STATE_LOCKED:
			new_anim = "open"
			STATE_OPEN = 1
			STATE_LOCKED = 0
		elif STATE_OPEN:
			new_anim = "close"
			STATE_OPEN = 0
			STATE_LOCKED = 1
	
	if new_anim != anim:
		anim = new_anim
		for child in get_children():
			if child.get_name() == "door":
				get_node(child.get_name()).get_node("anim").play(new_anim)
		get_node("switch_anim").play(new_anim)