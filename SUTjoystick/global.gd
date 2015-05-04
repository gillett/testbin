extends Node


##################################################################
# start scene switcher
var current_scene = null
func goto_scene(scene):
	scene = "res://" + scene + ".xscn"
	call_deferred("_swap_scene", scene)
func _swap_scene(scene):
	var s = ResourceLoader.load(scene)
	current_scene.free()
	current_scene = s.instance()
	get_tree().get_root().add_child(current_scene)
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
# end scene switcher
##################################################################