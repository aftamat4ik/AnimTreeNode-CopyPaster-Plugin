tool
extends EditorInspectorPlugin

# Refrence to owner-plugin
var _plugin:EditorPlugin

const ui_utility_class := preload("res://addons/animtree_node_helpers/Ui/VbUtility.tscn")

# We can't instanciate our UI in here
# Since Inspector clears all it's widgets every time user switch an object
# So we should instanciate or utility ui Every Time and re-add it every time
# Because of that here will be just empty variable
var ui_instance

# Pseudo-Constructor
func init(plugin:EditorPlugin):
	_plugin = plugin

# Objects types that will have our submenu ui in Inspector
func can_handle(object):
	if object is AnimationNode:
		return true
	return false

# Add controls to the beginning of inspector property list
func parse_begin(object):
	if object is AnimationNode:
		var anim_node = object as AnimationNode
		
		_plugin.get_singleton().current_node = anim_node
		
		ui_instance = ui_utility_class.instance()
		# Add Ui
		add_custom_control(ui_instance)
		# Call Constructor
		ui_instance.init(_plugin, self)
