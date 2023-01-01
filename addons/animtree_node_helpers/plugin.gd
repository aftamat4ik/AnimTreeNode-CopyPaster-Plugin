tool
extends EditorPlugin

var inspector_utility:EditorInspectorPlugin

const inspector_utility_class = "res://addons/animtree_node_helpers/InspectorPlugin.gd"
const refrences_singleton_class = "res://addons/animtree_node_helpers/Helpers/NodeRefrences.gd"
const singleton_name = "AnimNodeRefrences"

func _enter_tree():
	if inspector_utility == null:
		# Register inspector_utility as Inspector plugin
		inspector_utility = preload(inspector_utility_class).new()
		add_inspector_plugin(inspector_utility)
		# Call Constructor
		inspector_utility.init(self)
	if get_node_or_null("/root/"+singleton_name) == null:
		add_autoload_singleton(singleton_name, refrences_singleton_class)

func _exit_tree():
	if inspector_utility != null:
		inspector_utility.clear_instance()
		# Clear inspector_utility registration
		remove_inspector_plugin(inspector_utility)
	remove_autoload_singleton(singleton_name)

func handles(object):
	if object is AnimationTree:
		return true
	return false

func edit(object):
	# save last tree node as well
	if object is AnimationTree:
		var tree := object as AnimationTree
		get_singleton().last_tree_node = tree

func get_singleton()->Node:
	#return ATH_AnimNodeRefrences#get_node_or_null("/root/"+singleton_name)
	return get_node_or_null("/root/"+singleton_name)
