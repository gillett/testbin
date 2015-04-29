extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

var bullet = preload("res://weapons/bullet.xml")

var gun_angle = 0
var barrel_tip_pos
export var ship_pos = Vector2(0,0)
var mouseX 
var mouseY 
var shooting = false
var bullet_speed = 800
var last_shot = .3


func _fixed_process(delta):
	ship_pos = get_parent().get_pos()
	var mouse_pos = get_viewport_transform().affine_inverse().xform(Input.get_mouse_pos())
	
	# Lerping the speed of the gun allows a more natural feel
	mouseX = lerp(mouseX, mouse_pos.x, 0.04)
	mouseY = lerp(mouseY, mouse_pos.y, 0.04)
	
	# Calculate the angle from the ship to the mouse position
	#gun_angle = ship_pos.angle_to_point(Vector2(mouseX, mouseY)) v1
	#gun_angle = lerp(gun_angle, ship_pos.angle_to_point(mouse_pos),0.04) v1.1
	gun_angle = ship_pos.angle_to_point(mouse_pos)
	
	# Set angle of gun to that of angle calculated 
	set_rot(gun_angle)
	
	# Not sure if I'll keep this part but we've set 5 nodes to be the location
	# of the bullet when it is instanced. randi() generates one of those 5 positions
	var tip_pos_id = "barrel_tip"+str(randi() % 5 + 1)

	# Get the tip of the generated position
	barrel_tip_pos = get_node(str(tip_pos_id)).get_global_pos()
		
	if Input.is_action_pressed("main_gun"):
		last_shot = last_shot + (delta * 5)
		if last_shot >= .2:
			last_shot = 0
			var bi = bullet.instance()
			bi.set_pos(_barrel_tip_pos())
			bi.set_rot(get_rot())
			get_parent().get_parent().add_child(bi)
			
			bi.set_linear_velocity((mouse_pos - ship_pos).normalized() * bullet_speed)
			#PS2D.body_add_collision_exception(bi.get_rid(),get_rid()) # make bullet and this not collide
func _ready():
	# Initialization here
	mouseX = 0 #get_node("ship").get_pos().x
	mouseY = 0 #get_node("ship").get_pos().y
	set_fixed_process(true)
	pass

func _barrel_tip_pos():
	return barrel_tip_pos

