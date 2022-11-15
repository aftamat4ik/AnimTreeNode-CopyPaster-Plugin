tool
extends Node
# Since EditorPlugin dosen't save it's states between scene updates
# i have to store copied nodes in global loaded singleton

# Cached Nodes
var buffered_node:AnimationNode
var current_node:AnimationNode
var last_tree_node:AnimationTree
