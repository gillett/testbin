extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

export var motion = Vector2()
export var cycle = 1.0
var accum=0.0

func _fixed_process(delta):

	accum += delta * (1.0/cycle) * PI * 2.0
	#print(accum)
	accum = fmod(accum,PI*2.0)
	var d = sin(accum)
	var xf = Matrix32()
	xf[2]= motion * d 
	#print(xf)
	get_node("spike_box").set_transform(xf)
		

func _ready():
	# Initalization here
	set_fixed_process(true)
	pass

func _on_Area2D_body_enter( body ):
	if body extends preload("res://rocket.gd"):
		print("ship hit me")
	pass # replace with function body
