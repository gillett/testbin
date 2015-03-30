extends Node2D

var max_hp = 6
var hp

var isSpacePressed = false
var isMouseClicked = false

func _ready():

	hp = max_hp
	get_node("HP").get_node("hp_bar").set_max(hp)
	get_node("HP").get_node("hp_bar").set_value(hp)
	get_node("HP").get_node("hp_bar_textured").set_max(hp)
	get_node("HP").get_node("hp_bar_textured").set_value(hp)
	set_process(true)
	set_fixed_process(true)
	
	
func _process(delta):
	if Input.is_action_pressed("Space"):
		if isSpacePressed == false:
			var damage = 1
			var newVal = hp - damage
			hp = hp - damage
			get_node("HP").get_node("hp_bar").set_value(newVal)
			get_node("HP").get_node("hp_bar_textured").set_value(newVal)
			isSpacePressed = true
			
	else:
		isSpacePressed = false

	if Input.is_action_pressed("mouse_left"):
		if isMouseClicked == false:
			print(Input.get_mouse_pos())
			isMouseClicked = true
	else:
		isMouseClicked = false

func _on_body_enter( body ):

	pass # replace with function body


func _on_area2d_body_enter( body ):
	print("Enter")
