extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var STATE_LOCKED = 1
var STATE_OPEN = 0
export var key_colour = ""

var anim = ""
func _ready():
	#if key_colour == "blue":
	#	get_node("blue").set_color(Color(0,0,255,255))
	#if key_colour == "red":
	#	get_node("red").set_color(Color(255,0,0,255))
	#if key_colour == "yellow":
	#	get_node("yellow").set_color(Color(255,255,0,255))
	get_node(str(key_colour)).show()
	get_node("switch_anim").play(str(key_colour))
	# Initialization here
	#anim = "locked"
	#get_node("switch_anim").play(anim)
	pass

func _has_valid_key(playerKeyArray):
	for playerkey in playerKeyArray:
		if playerkey == key_colour:
			return true
		else: 
			return false
func _on_Area2D_body_enter( body ):

	var new_anim = anim
	if body.get_name() == "rocket":
		if STATE_LOCKED:
			if (body.has_valid_key(key_colour)):
				get_node("door").get_node("anim").play("open")
				get_node("open").show()
				STATE_OPEN = 1
				STATE_LOCKED = 0
		elif STATE_OPEN:
			get_node("open").hide()
			get_node("switch_anim").play(str(key_colour))
			get_node("door").get_node("anim").play("close")
			STATE_OPEN = 0
			STATE_LOCKED = 1
	
	#if new_anim != anim:
	#	anim = new_anim
	#	for child in get_children():
	#		if child.get_name() == "door":
	#			get_node(child.get_name()).get_node("anim").play(new_anim)
	#	get_node("switch_anim").play(new_anim)

