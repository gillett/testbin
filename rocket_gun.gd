extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var bullet = preload("res://weapons/bullet.xml")

var gun_angle
var barrel_tip_pos
export var ship_pos = Vector2(0,0)
var mouseX 
var mouseY 
var shooting = false


func _fixed_process(delta):
	ship_pos = get_parent().get_pos()
	var mouse_pos = get_viewport_transform().affine_inverse().xform(Input.get_mouse_pos())
	
	mouseX = lerp(mouseX, mouse_pos.x, 0.3)
	mouseY = lerp(mouseY, mouse_pos.y, 0.3)
	gun_angle = ship_pos.angle_to_point(Vector2(mouseX, mouseY))
	
	if Input.is_action_pressed("main_gun") && shooting == false:
		var bi = bullet.instance()
		bi.set_pos(_barrel_tip_pos())
		print(bi)
		get_parent().get_parent().add_child(bi)
		bi.set_angular_velocity(gun_angle + (4000 *delta))
	 
	set_rot(gun_angle)
	barrel_tip_pos = get_node("barrel_tip").get_global_pos()
func _ready():
	# Initialization here
	mouseX = 0 #get_node("ship").get_pos().x
	mouseY = 0 #get_node("ship").get_pos().y
	set_fixed_process(true)
	pass

func _barrel_tip_pos():
	return barrel_tip_pos

