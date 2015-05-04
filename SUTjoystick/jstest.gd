
extends Node2D

# SUTjoystick GUI
# Written by Dana Olson <dana@shineuponthee.com>
#
# This is a demo of joystick support, and doubles as a testing application
# inspired by and similar to jstest-gtk.
#
# It has been tailored to use the SUTjoystick module.
#
# Originally based on the Joysticks demo submitted for inclusion in Godot, which is under the MIT license.

var joy_num
var cur_joy
var axis_value
var btn_state
var JS

func _ready():
	OS.set_window_title("SUTjoystick GUI")
	JS = get_node("/root/SUTjoystick")
	JS.disable_fallback_map = true
	JS.emulate_mouse(true)
	# connect the disconnect buttons in the Multi view
	for player in range(1,5):
		get_node("tabs/Multi/player"+str(player)+"/diagram/btn_deregister").connect("pressed",JS,"deregister_player",[player])
	set_process(true)
#	set_process_input(true)

#func _input(event):
#	print(event)

func _process(delta):
	cur_joy = JS.get_device_number()
	# display the name of the joystick if we haven't already
	if joy_num != cur_joy:
		joy_num = cur_joy
		get_node("joy_num").set_text(str(cur_joy))
		var joy_name = Input.get_joy_name(cur_joy)
		var joy_md5 = joy_name.md5_text()
		get_node("joy_name").set_text( joy_name )
		if joy_name:
			get_node("joy_md5").set_text( str(joy_md5) )
	
	# loop through the axes and show their current values
	for axis in range(0,8):
		axis_value = Input.get_joy_axis(joy_num,axis)
		get_node("tabs/Raw/axis_prog"+str(axis)).set_value(100*axis_value)
		get_node("tabs/Raw/axis_val"+str(axis)).set_text(str(axis_value))
	
	# loop through the buttons and highlight the ones that are pressed
	for btn in range(0,17):
		btn_state = 1
		if (Input.is_joy_button_pressed(joy_num, btn)):
			get_node("tabs/Raw/btn"+str(btn)).add_color_override("font_color",Color(1,1,1,1))
		else:
			get_node("tabs/Raw/btn"+str(btn)).add_color_override("font_color",Color(0.1,0.1,0.1,1))
	
	# loop through the digital states and turn on/off the diagram indicators
	for indicator in get_node("diagram").get_children():
		if indicator extends Sprite:
			indicator.set_opacity(JS.get_digital(indicator.get_name()))
	
	# loop through the four controllers on the Multi tab
	for player in range(1,5):
		# gray out the player number if no device is attached
		if JS.get_device_number(player) == -1:
			get_node("tabs/Multi/player"+str(player)).add_color_override("font_color",Color(0.1,0.1,0.1,1))
			get_node("tabs/Multi/player"+str(player)).set_tooltip("No device assigned")
			get_node("tabs/Multi/player"+str(player)+"/diagram/btn_deregister").hide()
		else:
			get_node("tabs/Multi/player"+str(player)).add_color_override("font_color",Color(1,1,1,1))
			get_node("tabs/Multi/player"+str(player)).set_tooltip(JS.get_device_name(player))
			get_node("tabs/Multi/player"+str(player)+"/diagram/btn_deregister").show()
		# light up the diagram indicators
		for indicator in get_node("tabs/Multi/player"+str(player)+"/diagram").get_children():
			if indicator extends Sprite:
				indicator.set_opacity(JS.get_digital(indicator.get_name(), player))

	# show the numeric values of the analog states
	for analog_name in JS.analog_state[0]:
		var component = analog_name.replace("_","/")
		get_node("tabs/Analog/"+component+"_val").set_text(str(JS.get_analog(analog_name)))
		get_node("tabs/Analog/"+component+"_prog").set_value(100 * JS.get_analog(analog_name))

#	get_node("tabs/Analog/leftstick/angle").set_text(str(JS.get_angle("leftstick")))
#	get_node("tabs/Analog/rightstick/angle").set_text(str(JS.get_angle("rightstick")))
#	get_node("tabs/Analog/dpad/angle").set_text(str(JS.get_angle("dpad")))

	return


func _on_joy_num_value_changed( value ):
# if user uses the spinbox, update the name+md5 display.
# pushing a button on a pad will switch automatically, but this is useful to me for getting md5sums.
	var joy_name = Input.get_joy_name(value)
	var joy_md5 = joy_name.md5_text()
	get_node("joy_name").set_text( joy_name )
	if joy_name:
		get_node("joy_md5").set_text( str(joy_md5) )
	else:
		get_node("joy_md5").set_text("")
	return


func _on_btn_mapper_pressed():
	get_node("/root/global").goto_scene("jsmapper")
	return
