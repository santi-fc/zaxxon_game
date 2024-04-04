extends Node

# Scene places
const SCENE_START_PATH    = "res://scenes/02_start_screen.tscn"
const SCENE_OPTION_SCREEN = "res://scenes/02b_options_screen.tscn"
const SCENE_MAIN_GAME     = "res://scenes/03_main.tscn"
const SCENE_GAME_OVER     = "res://scenes/04_game_over.tscn"

var MUSIC_INTRO  = load( "res://sound/main_menu.ogg" )
var MUSIC_LEVEL_1 = load( "res://sound/Level_1.ogg" )

# Game variables
var score : int  = 0
var game_speed : float = 0.6 # 0.6
var max_lives : int = 3
var current_lives : int = 3

# Game behaviour
var current_scene : Node
var level_moving : bool = false
var player_stopped : bool = false
var player_to_center : bool = false
var player_to_center_speed : float = 2
var player : Node
var player_can_fire : bool = true
var score_label : Label
var level_boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.09 }

var master_sound_bus = AudioServer.get_bus_index("Master")
var current_master_volume = -10
var game_player
var current_song

var camera_speed = 1
var camera_player_position
var move_camara_to_front : bool = false

const SAVE_PATH = "user://zaxxon.ini"

func _ready() -> void :
	self.load_config()
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() - 1 )
	change_volume( GLOBAL.master_sound_bus, GLOBAL.current_master_volume )
	game_player = GLOBALSCENE.get_node('GlobalPlayer')

func _process( _delta ) -> void :
	if move_camara_to_front :
		var camera : Camera3D = current_scene.get_node( "CameraPivot/Camera" )
		var player_camera : Camera3D = player.get_node( 'Camera3D' )
		var move_camera_position = Vector3( player_camera.global_transform.origin.x, player_camera.global_transform.origin.y, player_camera.global_transform.origin.z - 0.5 )
		camera.global_transform.origin = lerp( camera.global_transform.origin, move_camera_position , _delta * camera_speed )
		
		var player_direction = player_camera.global_transform.basis
		var current_rotation = Quaternion( camera.basis )
		var next_rotation = current_rotation.slerp( Quaternion( player_direction ), _delta * camera_speed)
		camera.global_transform.basis = Basis( next_rotation )


func start_game() -> void :
	GLOBAL.score = 0
	GLOBAL.current_lives = GLOBAL.max_lives
	GLOBAL.play_song( 'level_1' )
	goto_scene( GLOBAL.SCENE_MAIN_GAME )


func exit_game() -> void :
	get_tree().quit()


func go_to_start() -> void :
	goto_scene( GLOBAL.SCENE_START_PATH )


func go_to_options() -> void :
	goto_scene( GLOBAL.SCENE_OPTION_SCREEN )


func reload_level() -> void :
	goto_scene( GLOBAL.SCENE_MAIN_GAME )


# Public scene change function
func goto_scene( path ) -> void :
	call_deferred( "_deferred_goto_scene", path )


func _deferred_goto_scene( path ) -> void :
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


func maximize_window() -> void :
	DisplayServer.window_set_mode( DisplayServer.WINDOW_MODE_MAXIMIZED )


func object_killed( _type ) -> void :
	match _type :
		'base' :
			GLOBAL.add_score( 20 )
		'torreta' :
			GLOBAL.add_score( 100 )
		'rocket' :
			GLOBAL.add_score( 150 )
		'enemy' :
			GLOBAL.add_score( 200 )

func add_score( _score : int ) -> void :
	GLOBAL.score = GLOBAL.score + _score
	update_score()


func update_score() -> void :
	GLOBAL.score_label.text = "%05d" % GLOBAL.score	


func change_volume( _bus : int, _percent : float ) -> void :
	GLOBAL.current_master_volume = _percent
	AudioServer.set_bus_volume_db( _bus, _percent )


func play_song( _song ) -> void :
	if not ( current_song == _song && game_player.playing ) :
		current_song = _song
		if ( _song == 'intro' ) :
			game_player.stream = GLOBAL.MUSIC_INTRO
		if _song == 'level_1' : 	
			game_player.stream = GLOBAL.MUSIC_LEVEL_1
		game_player.play()
		

func stop_song() -> void :
	game_player.stop()

func set_camara_front() -> void :
	move_camara_to_front = true
	await get_tree().create_timer( 2.5 ).timeout
	move_camara_to_front = false
	GLOBAL.player_stopped = false
	GLOBAL.player_to_center = false


func save_config() -> void :
	var config := ConfigFile.new()
	config.load( SAVE_PATH )
	config.set_value( name, "main_volume", current_master_volume )
	config.save( SAVE_PATH )

func load_config() -> void :
	var config := ConfigFile.new()
	config.load( SAVE_PATH )
	self.current_master_volume = config.get_value( name, "main_volume", current_master_volume )
