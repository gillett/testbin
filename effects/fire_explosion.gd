
extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _set_size(size):
	if size == "small":
		set_scale(0.3,0.3)
	elif size == "medium":
		set_scale(0.5,0.5)

func _ready():
	# Initialization here
	pass
func _explode():
	get_node("anim").play("die")

func _die():
	queue_free()

