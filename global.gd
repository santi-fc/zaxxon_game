extends Node

# Scene places
const SCENE_START_PATH = "res://scenes/start_screen.tscn"
const SCENE_MAIN_GAME  = "res://main.tscn"
const SCENE_GAME_OVER  = "res://scenes/game_over.tscn"

# Game variables
var score : int  = 0
var game_speed : float = 0.6
var current_game_speed : float = 0.6
var max_lives : int = 3
var current_lives : int = 3

# Game behaviour
var current_scene : Node
var level_moving : bool = false
var player : Node
var player_can_fire : bool = true


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() - 1 )


func _process(_delta):
	pass


func start_game():
	goto_scene( GLOBAL.SCENE_MAIN_GAME )


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


