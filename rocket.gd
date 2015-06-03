extends Node2D

# Enemies
var JS
var input_states = preload("res://input_states.gd")

export var player_speed = 0
export var acceleration = 0
export var thrust_acceleration = float(0.00)
export var thrust_speed = 0
var current_speed = Vector2(0,0)
var current_thrust = Vector2(0,0)
var current_gravity = Vector2(0,0)

# raycast control variable (stems from bottom of ship)
var raycast_down = null

# Key variables
var has_red_key = false
var has_blue_key = false
var has_yellow_key = false
var has_boss_key = false

var btn_right = input_states.new("ui_right")
var btn_left = input_states.new("ui_left")
var btn_up = input_states.new("ui_up")

func move(speed, acc, delta):
	# Moves the ship left or right
	current_speed.x = lerp(current_speed.x, speed, acc * delta)
	set_linear_velocity(Vector2(current_speed.x,get_linear_velocity().y))
func thrusters(speed, acc, delta):
	# Moves the ship up (gravity pulls it down)
	current_thrust.y = lerp(current_thrust.y, speed, acc * delta)
	set_linear_velocity(Vector2(get_linear_velocity().x, current_thrust.y))
func is_on_ground():
	if raycast_down.is_colliding():
		return true
	else:
		return false
func _ready():
	JS = get_node("/root/SUTjoystick")
	raycast_down = get_node("RayCast2D")
	raycast_down.add_exception(self)

	#set_applied_force(Vector2(0, extra_gravity))
	set_process_input(true)
			

func _integrate_forces(state):

	var lv = state.get_linear_velocity()
	var step = state.get_step()


	if btn_up.check() == 2 || JS.get_digital("leftstick_up"):
		thrusters(-thrust_speed, thrust_acceleration, step)
		get_node("thrust_on").show()
	else:
		get_node("thrust_on").hide()
		current_thrust.y = get_linear_velocity().y
		
	if !is_on_ground():	
		if btn_left.check() == 2 || JS.get_digital("leftstick_left"):
			move(-player_speed, acceleration, step)
		elif btn_right.check() ==2 || JS.get_digital("leftstick_right"):
			move(player_speed, acceleration,step)
		else:
			move(0, acceleration, step)
	
func _on_Area2D_body_enter( body ):
	var bn = body.get_name()
	print(bn)
	if bn == 'spike_box':
		print("DEATH")
	pass # replace with function body
	
func get_key(key_colour):
	#print("got key: "+str(key_colour))
	if key_colour == 'red':
		has_red_key = true
	if key_colour == 'blue':
		has_blue_key = true
	if key_colour == 'yellow':
		has_yellow_key = true

func has_valid_key(key_colour):
	var has_key = 0
	if key_colour == 'red' && has_red_key:
		has_key = 1
	if key_colour == 'blue' && has_blue_key:
		has_key = 1
	if key_colour == 'yellow' && has_yellow_key:
		has_key = 1

	if has_key:
		return true