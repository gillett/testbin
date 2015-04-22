
extends Node2D

# idles a computer screen when not hit or destroyed
# operates an electric door; deletes door node when destroyed
# after being destroyed, a smoldering/sparking animation is played

var STATE_RUNNING = 1
var STATE_DESTROYED = 0

var MAXHEALTH = 3

var anim = ""
func _ready():
	# Initialization here
	#anim = "locked"
	#get_node("switch_anim").play(anim)
	pass

func _do_damage(dmg):
	MAXHEALTH = MAXHEALTH - dmg

func _kill_doors():
	for i in get_children():
		i.queue_free()

func _on_Area2D_body_enter( body ):

	var new_anim = anim
	if body.get_name() == "bullet":
		if STATE_RUNNING:
			_do_damage(1)
			new_anim = "hit"
			if MAXHEALTH < 1:
				new_anim = "die"
				STATE_DESTROYED = 1
				STATE_RUNNING = 0
	
	if new_anim != anim:
		anim = new_anim
		get_node("anim").play(new_anim)
	pass # replace with function body
