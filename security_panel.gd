
extends Area2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass

func _on_Area2D_body_enter( body ):
	print(body.get_name())
	pass # replace with function body

