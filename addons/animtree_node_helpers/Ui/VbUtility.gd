tool
extends VBoxContainer

# *source files to look at
# scene/animation/animation_node_state_machine.cpp - add_node implementation
# /editor/plugins/animation_blend_tree_editor_plugin.cpp - rmb menu
# /editor/plugins/animation_tree_editor_plugin.cpp - enter_editor() - dosen't exposed to gdscript so no way of refreshing from it... that's bad

# Refrence to owner-plugin
var _plugin:EditorPlugin
var _inspector_plugin:EditorInspectorPlugin
var _singleton

# OnReady
onready var btn_copy := get_node("%BtnCopy")
onready var btn_paste := get_node("%BtnPaste")
onready var lbl_node_type := get_node("%Lbl_BufferedNodeType")

# Pseudo-Constructor
# there is no way of overriding node instance constructors, so i have to use this instead
func init(plugin:EditorPlugin, inspector_plugin:EditorInspectorPlugin):
	_plugin = plugin
	_inspector_plugin = inspector_plugin
	_singleton = plugin.get_singleton()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Bindings
	btn_copy.connect("pressed", self, "on_copy")
	btn_paste.connect("pressed", self, "on_paste")
	
	if get_current_node() is AnimationNode:
		$HBoxContainer.visible = true
	else:
		$HBoxContainer.visible = false
	update_states()

# Bindings

# Copy
func on_copy():
	buffer_node(get_current_node())

# Paste
func on_paste():
	var bnode = get_buffer_node()
	var current_node = get_current_node()
	if bnode != null and (current_node is AnimationNodeBlendTree or current_node is AnimationNodeStateMachine):
		# since nodes are resources - we can just duplicate them
		var dublicated = bnode.duplicate()
		
		# there is NO, literally NO way of getting AnimationNode name because it's not implemented!
		# ps. hey! please, someone! fix godot's AnimationTree and AnimationNode classes already. 
		current_node.add_node("Pasted Node " + (dublicated.get_instance_id() as String), dublicated, Vector2(0,0))
		
		# trying to refresh
		# i don't know how to refresh it since no methods of douing this are exposed
		# none of below is working
		property_list_changed_notify()
		#get_last_tree_node().property_list_changed_notify()
		#get_last_tree_node().emit_changed()
		
		_singleton.last_tree_node.tree_root.emit_signal("tree_changed")
		_singleton.last_tree_node.tree_root.property_list_changed_notify()

# Updates label text
func update_states():
	var bnode = get_buffer_node()
	
	var current = get_current_node()
	var last_tree_node = get_last_tree_node()
	var can_paste = current != bnode and (current is AnimationNodeBlendTree or current is AnimationNodeStateMachine)
	
	if bnode != null:
		lbl_node_type.text = "in buffer: " + bnode.get_class()
		# we can paste only to trees
		btn_paste.disabled = not can_paste
	else:
		lbl_node_type.text = ""
		btn_paste.disabled = true

# Buffer

# Add node to Buffer
func buffer_node(node:AnimationNode):
	if _singleton == null:
		return
	_singleton.buffered_node = node
	update_states()

func get_buffer_node()->AnimationNode:
	return _singleton.buffered_node if _singleton != null else null

func get_current_node()->AnimationNode:
	return _singleton.current_node if _singleton != null else null

func get_last_tree_node()->AnimationNode:
	return _singleton.last_tree_node if _singleton != null else null


# Clear node from Buffer
func clear_buffer():
	_singleton.buffered_node = null
	update_states()

