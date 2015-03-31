extends Node2D

# Enemies
var spike_class = preload("res://enemies/spike_box.gd")
var input_states = preload("res://input_states.gd")

export var player_speed = 0
export var acceleration = 0
export var thrust_acceleration = float(0.00)
export var thrust_speed = 0
var current_speed = Vector2(0,0)
var current_thrust = Vector2(0,0)
var current_gravity = Vector2(0,0)
export var winds = float(20.0)
export var extra_gravity = 0

var raycast_down = null

var btn_right = input_states.new("ui_right")
var btn_left = input_states.new("ui_left")
var btn_up = input_states.new("ui_up")

func move(speed, acc, delta):
	current_speed.x = lerp(current_speed.x, speed, acc * delta)
	set_linear_velocity(Vector2(current_speed.x,get_linear_velocity().y))


func thrusters(speed, acc, delta):
	current_thrust.y = lerp(current_thrust.y, speed, acc * delta)
	set_linear_velocity(Vector2(get_linear_velocity().x, current_thrust.y))
func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false
func _ready():
	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)

	#set_applied_force(Vector2(0, extra_gravity))
	set_process_input(true)
			

func _integrate_forces(state):

	var lv = state.get_linear_velocity()
	var step = state.get_step()

	#var current_velocity = get_linear_velocity()	
	if btn_up.check() == 2:
		thrusters(-thrust_speed, thrust_acceleration, step)
		get_node("thrust_on").show()
	else:
		get_node("thrust_on").hide()
		current_thrust.y = get_linear_velocity().y
		
	if !is_on_ground():	
		if btn_left.check() == 2:
			move(-player_speed, acceleration, step)
		elif btn_right.check() ==2:
			move(player_speed, acceleration,step)
		else:
			move(0, acceleration, step)
	if btn_up.check() == 2:
		thrusters(-thrust_speed, thrust_acceleration, step)
		get_node("thrust_on").show()
	else:
		get_node("thrust_on").hide()
		current_thrust.y = get_linear_velocity().y
		
	for i in range(state.get_contact_count()):
		var cc = state.get_contact_collider_object(i)
		var dp = state.get_contact_local_normal(i)
	
func _on_Area2D_body_enter( body ):
	#print(body.get_name())
	if body.get_name() == 'spike_box':
		print("DEATH")
	pass # replace with function body
