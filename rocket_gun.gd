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
var bullet_speed = 800
var last_shot = .5


func _fixed_process(delta):
	ship_pos = get_parent().get_pos()
	var mouse_pos = get_viewport_transform().affine_inverse().xform(Input.get_mouse_pos())
	
	mouseX = lerp(mouseX, mouse_pos.x, 0.2)
	mouseY = lerp(mouseY, mouse_pos.y, 0.2)
	gun_angle = ship_pos.angle_to_point(Vector2(mouseX, mouseY))
	
	if Input.is_action_pressed("main_gun"):
		last_shot = last_shot + (delta * 5)
		if last_shot >= .2:
			last_shot = 0
			var bi = bullet.instance()
			bi.set_pos(_barrel_tip_pos())
			get_parent().get_parent().add_child(bi)
			
			# set random values for spray effect
			# not as good as thought before... removing
			#mouse_pos.x = mouse_pos.x + rand_range(-10,10)
			#mouse_pos.y = mouse_pos.y + rand_range(-10, 10)

			bi.set_linear_velocity((mouse_pos - ship_pos).normalized() * bullet_speed)
			#PS2D.body_add_collision_exception(bi.get_rid(),get_rid()) # make bullet and this not collide


	# Set angle of gun to that of angle calculated 
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

