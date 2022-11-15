tool
extends VBoxContainer


# Refrence to owner-plugin
var _plugin:EditorPlugin
var _inspector_plugin:EditorInspectorPlugin
var _singleton

const inspector_class = "res://addons/animtree_node_helpers/ATH_InspectorPlugin.gd"

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
		var dublicated = bnode.duplicate()
		
		# there is NO, literally NO way of getting AnimationNode name because it's not implemented!
		# hey! please, someone! fix godot's AnimationTree and AnimationNode classes already. 
		# Commit some changes in there.
		# AnimationTree api is not feature complete. It's ... like in early alpha stage right now
		# *why don't do it myself if i need so? I Have HDD on my PC and old processor
		# it will take AGES for me to rebuild and test stuff on godot's sources using scons before committing it
		# so i'l not do it, sorry
		# also since now godot leading two api (gdscript + c#) even if i would do new api for the gdscript classes, it will not affect godot's c#
		# and i tryed to compile godot with mono together with no success. 
		# Go and try it yourself maybe you'l have better luck on this.
		
		# what features are necessary for AnimationTree? (my opinion)
		# get node name
		# get parent
		# get child by name
		# get list of child nodes
		# automatic registration of custom nodes inherited from AnimationNode on Animation Tree's RMB menu
		# splitting that menu to categories, such as
		# blends -> blend2, blend3
		# additives -> Add2, Add3
		# and so on
		# and ofcourse categories are Enum E_AnimationNodeCategory: blends, additives, animation, misc
		# ofcourse custom nodes that extend AnimationNode class should have function:
		# _get_category_id->E_AnimationNodeCategory
		# by overriding it user can specify in which category this node will appear
		# also we need some kind'a 2d cursor like in Blender
		# to get it's coordinates and spawn nodes on on Vector2(0,0), but on cursor's coordinates
		current_node.add_node("Pasted Node " + (dublicated.get_instance_id() as String), dublicated, Vector2(0,0))
		# trying to refresh
		property_list_changed_notify()
		_plugin.get_singleton().last_tree_node.property_list_changed_notify()
		_plugin.get_singleton().last_tree_node.emit_changed()

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

