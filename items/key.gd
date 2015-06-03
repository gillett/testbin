
extends Node2D

var ship_class = preload("res://rocket.gd")
export var key_colour = ""
# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	if key_colour == "blue":
		get_node("colour").set_color(Color(0,0,255,255))
	if key_colour == "red":
		get_node("colour").set_color(Color(255,0,0,255))
	if key_colour == "yellow":
		get_node("colour").set_color(Color(255,255,0,255))
	pass


func _on_Area2D_body_enter( body ):
	if body extends ship_class:
		print("ship")
		body.get_key(key_colour)
		queue_free()
	pass # replace with function body
	
func get_key_colour():
	return key_colour
