
extends Node2D

# SUTjoystick Mapper
# Written by Dana Olson <dana@shineuponthee.com>
#
# License: MIT (same as Godot Engine)
#
# This is a tool used to easily create new or custom mappings for use with the SUTjoystick module.
# It is not perfect, but takes away most of the hard work.
# If a device sends an axis AND a button event for the same input (eg: DualShock 3's d-pad), it might not
# map 100% correctly.
# Polarity on triggers may sometimes be reversed if the trigger has its own axis and ranges from -1 to +1.
# This tool attempts to fix it automatically, but every device is different, and so in some rare cases,
# some manual tweaking of the mapping file may be required.
#
# Created mappings are stored in user:// and can then be copied to other games or integrated directly into this project.
# It will override anything not built-in to this project.
# Send a pull request on GitLab or send an email directly (via Upload button!) to the author with the new mapping.

var joy_num = 0
var cur_joy
var joy_name
var collect_junk = false # flag for when collecting junk input
var junk_axes = []
var junk_btns = []
var axdz = 0.8 # axis deadzone for detecting an input or noise
var JS
var map # where we build the new joystick map

var inputs = ["action_1","action_2","action_3","action_4","start",
"back","home","click_left","click_right","bump_left","bump_right",
"trig_left", "trig_right",
"dpad_up","dpad_down","dpad_left","dpad_right",
"leftstick_up","leftstick_down","leftstick_left","leftstick_right",
"rightstick_up","rightstick_down","rightstick_left","rightstick_right"]
var input_num = -1 # which input are we trying to read?


func _ready():
	OS.set_window_title("SUTjoystick Mapper")
	JS = get_node("/root/SUTjoystick")
	map = JS.js_map_template
	# hide the button lights
	for sprite in get_node("diagram").get_children():
		if sprite extends Sprite:
			sprite.hide()
	# process input
	set_process_input(true)
	update_joystick_info()
	get_node("btn_upload").hide()
	return


func update_joystick_info():
	# display the name of the joystick if we haven't already
	if joy_num != cur_joy:
		cur_joy = joy_num
		joy_name = Input.get_joy_name(joy_num)
		get_node("joy_name").set_text( joy_name )
		get_node("common_name").set_text( joy_name )
		if joy_name:
			get_node("joy_md5").set_text( joy_name.md5_text() )
		else:
			get_node("joy_md5").set_text("")
	return


func _input(ev):
	# only handle joystick input
	if ev.type == InputEvent.JOYSTICK_BUTTON or ev.type == InputEvent.JOYSTICK_MOTION:
		# ignore input from anything other than the current joystick
		if ev.device != cur_joy:
			return
		var id
		# collect junk input
		if collect_junk:
			if ev.type == InputEvent.JOYSTICK_MOTION:
				id = ev.axis + 1
				if ev.value < 0:
					id = -id
				if id in junk_axes:
					return
				elif abs(ev.value) >= axdz: # only junk the axis if it's ultra-noisy
					print("adding axis to junk array")
					junk_axes.push_back(id)
			elif ev.type == InputEvent.JOYSTICK_BUTTON:
				id = ev.button_index
				if id in junk_btns:
					return
				else:
					print("adding button to junk array")
					junk_btns.push_back(id)
		# if the timer is counting down, skip the below
		if input_num < 0:
			return
		# grab the input
		if ev.type == InputEvent.JOYSTICK_MOTION:
			id = ev.axis + 1
			# negative axis id represents movement in the sub-zero direction
			if ev.value < 0:
				id = -id
			if id in junk_axes:
				return
			if input_num < 10: # no axis events for the first 10 inputs
				return
			if ev.value > -axdz and ev.value < axdz: # require big analog input to register
				return
			# we got a valid axis! stick it in the map
			map.axis[ inputs[input_num] ] = id
		if ev.type == InputEvent.JOYSTICK_BUTTON:
			id = ev.button_index
			if id in junk_btns:
				return
			if input_num > 16: # no button events after first 16 inputs
				return
			# we got a valid button! stick it in the map
			map.button[ inputs[input_num] ] = id
		# if we got here, the input was accepted
		action_accepted()
	return


func _on_btn_begin_pressed():
	map.name = get_node("joy_name").get_text()
	if map.name == "":
		get_node("instructions").set_text("Please select device.")
		get_node("instructions").show()
		return
	map.md5 = map.name.md5_text()
	map.os = OS.get_name().to_lower()
	collect_junk = true
	get_node("Timer").start()
	get_node("label_device").hide()
	get_node("joy_num").hide()
	get_node("btn_begin").hide()
	get_node("instructions").set_text("Do not touch the gamepad yet...")
	get_node("instructions").show()
	get_node("btn_cancel").show()
	get_node("btn_upload").hide()
	return


func _on_timer_timeout():
	collect_junk = false
	input_num += 1
	if input_num >= inputs.size():
		# done reading inputs
		input_num = -1
		get_node("label_device").show()
		get_node("joy_num").show()
		get_node("btn_begin").show()
		get_node("btn_cancel").hide()
		# trigger fix - most triggers are likely positive axes, so if they are not set to the same axis, set them positive
		if map["axis"]["trig_left"] and map["axis"]["trig_right"]:
			if abs(map["axis"]["trig_left"]) != abs(map["axis"]["trig_right"]):
				map["axis"]["trig_left"] = abs(map["axis"]["trig_left"])
				map["axis"]["trig_right"] = abs(map["axis"]["trig_right"])
		# grab the retail/common name
		map.common_name = get_node("common_name").get_text().strip_edges()
		if map.common_name == "":
			map.common_name = map.name
		# now we're ready to save it
		JS.save_mapping_file(map)
		get_node("instructions").set_text("Mapping file saved.")
		get_node("instructions").show()
		get_node("btn_upload").show()
	else:
		get_node("instructions").set_text("Press the indicated button:")
		get_node("instructions").show()
		get_node("diagram/"+inputs[input_num]).show()
		get_node("btn_skip").show()
	return


func _on_btn_cancel_pressed():
	get_node("Timer").stop()
	get_node("label_device").show()
	get_node("joy_num").show()
	get_node("btn_begin").show()
	get_node("instructions").hide()
	get_node("btn_cancel").hide()
	get_node("btn_skip").hide()
	get_node("diagram/"+inputs[input_num]).hide()
	input_num = -1
	collect_junk = false
	return


func action_accepted():
	# start the timer again
	get_node("Timer").start()
	# hide the indicator and instructions
	get_node("instructions").hide()
	get_node("diagram/"+inputs[input_num]).hide()
	get_node("btn_skip").hide()
	return


func _on_btn_quit_pressed():
	JS.active_map = [null,null,null,null]
	get_node("/root/global").goto_scene("jstest")
	return


func _on_btn_upload_pressed():
# upload the new mapping to shineuponthee.com
	var open = OS.shell_open("http://www.shineuponthee.com/index.pl?action=submit_js_map&js_map="+map.to_json())
	print(open)
	return


func _on_joy_num_value_changed( value ):
	joy_num = value
	update_joystick_info()
	return


func _on_deadzone_value_changed( value ):
	get_node("deadzone").set_tooltip(str(value)+"%")
	map.deadzone = value / 100
	pass # replace with function body
