extends Node

# Scene places
const SCENE_MAIN_PATH = "res://scenes/main.tscn"

# Game variables
var score : int  = 0

# Game behaviour
var current_scene = null

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() - 1 )

# Public scene change function
func goto_scene( path ):
	call_deferred( "_deferred_goto_scene", path )


func _deferred_goto_scene( path ):
	# Now its safe to remove the current scene
	current_scene.free()
	
	# Load the new scene
	var new_scene = ResourceLoader.load( path )
	
	# Instance the new scene
	current_scene = new_scene.instantiate()
	
	# Add it to the active scene, as child of root
	get_tree().get_root().add_child( current_scene )
	
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene


func maximize_window():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
