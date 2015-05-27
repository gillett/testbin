
extends StaticBody2D

# idles a computer screen when not hit or destroyed
# operates an electric door; deletes door node(s) when destroyed
# after being destroyed, a smoldering/sparking animation is played

var bullet_class = preload("res://weapons/bullet.gd")

var STATE_RUNNING = 1
var STATE_DESTROYED = 0

var MAXHEALTH = 10
var hit_count = 0

var anim = ""
func _ready():
	# Initialization here
	#anim = "locked"
	#get_node("switch_anim").play(anim)
	pass

func _do_damage(dmg):
	MAXHEALTH = MAXHEALTH - dmg
	
func _die():
	queue_free()

func _on_Area2D_body_enter( body ):
	var new_anim = anim
	if body extends bullet_class:
		if STATE_RUNNING:
			_do_damage(1)
			if !get_node("anim").is_playing():
				get_node("anim").play("hit")
			if MAXHEALTH < 1:
				get_node("anim").play("die")
				STATE_DESTROYED = 1
				STATE_RUNNING = 0
	#lse:
		#new_anim = "idle"
	
	#if new_anim != anim:
	#	anim = new_anim
	#	get_node("anim").play(new_anim)
	#pass # replace with function body
