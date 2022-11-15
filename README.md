# AnimTreeNode Helpers Plugin
 Godot Engine AnimTree plugin that allows user to copy / paste selected nodes

 ![Plugin Screen](/img/PluginMainScr.PNG)

 Since currently (12.11.2022) Godot 3.5 dosen't support anim tree nodes to be copied and pasted - i decided to implement this feature myself.
 It's very important feature, if your anim tree has a lot of animations and nodes with many states. Like main.

 Since godot's AnimTree Api is very limited all copied and pasted nodes will have name `PastedNode + InstanceId`. It's just impossible to get original selected node name from AnimTree. At least i did not found a way to do so.
 
 Also current Api donsen't allow from code to know if we in subtree or not. So it's impossible to make node paste into subtrees without directly selecting them.
 Plugin supports paste into `BlendTree` and `StateMachine` nodes.

 ![Supported Paste Nodes](/img/SupportedToPasteNodes.PNG)

 If your AnimTree's Root node is one of this nodes, you can paste in it as well, but you need to manually select tree root node by selecting `AnimationTree->TreeRoot`:

 ![Paste to TreeRoot](/img/PasteToAnimationTreeRoot.PNG)