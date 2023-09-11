extends Node

var player_scene 		= preload("res://player.tscn")
var fire_scene   		= preload("res://fire.tscn")
var fire_muro_particles = preload("res://particles/fire1.tscn")
var level 				= preload("res://niveles/nivel_1.tscn")

var player
var camera
var current_level
var current_level_num = 1
var current_time : float
var can_fire : bool = true

var max_lives = 3
var current_lives = 3

var game_speed = 0.6
var current_game_speed = 0.6


# Called when the node enters the scene tree for the first time.
func _ready():
	$StartScreen.visible = true
	$UI.visible = false
	$GameOverScreen.visible = false
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	$UI/Speed_Label.text = 'Speed: ' +  str(current_game_speed)
	$UI/ProgressBar.value = current_game_speed / game_speed * 100
	$UI/FPS.text = "FPS: " + str( Engine.get_frames_per_second() )

func _physics_process( delta ) :
	# Move player and camera
	current_time += delta
	if player && player.can_move :
		camera.position.z += current_game_speed * delta
		if ( current_time > 0.7 ) :
			player.position.z += current_game_speed * delta
	
func _unhandled_input( event ):
	
	# En la pantalla de start
	if $StartScreen.visible and ( event.is_action_pressed("ui_accept") || event.is_action_pressed( 'fire' ) ):
		# Game begins
		start_game()
		
	# En la pantalla de Game Over
	if $GameOverScreen.visible and ( event.is_action_pressed("ui_accept") || event.is_action_pressed( 'fire' ) ) :
		# Game restarts
		current_lives = 3
		update_lives()
		
		# TODO : Calcular esto
		var level_boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.11 }
		player.position =  Vector3( ( level_boundaries.left + level_boundaries.right ) / 2, 
									( level_boundaries.top - level_boundaries.bottom ) / 2 , 
									-2 )
		camera.position.z = -2
		$GameOverScreen.visible = false
		player.can_move = true

func load_level( _which_one ) :
	if ( current_level_num != _which_one ) :
		var level = load("res://niveles/nivel_1.tscn")
		
	var level_instance = level.instantiate()
	current_level = level_instance
	current_level_num = _which_one
	add_child( level_instance )
	

func start_game():
	# De momento siempre cargamos el nivel 1... (que bastante tenemos ya)
	load_level( 1 )
	
	$StartScreen.visible = false;
	$UI.show()
	
	# Añadimos jugador
	player = player_scene.instantiate()
	
	camera = get_node("CameraPivot");
	var level_boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.11 }
	
	# Lo ponemos mirando a donde toca
	player.rotation.y = PI
	
	# Lo centramos
	# TODO : Calcular esto
	player.position =  Vector3( ( level_boundaries.left + level_boundaries.right ) / 2, 
								( level_boundaries.top - level_boundaries.bottom ) / 2 , 
								-2 )
	camera.position.z = -2
	
	player.initialize( { 'level_boundaries' : level_boundaries } )
	add_child( player )
	

func make_fire() :
	if ( can_fire ) :
		can_fire = false
		$FireTimer.start()
		
		var fire = fire_scene.instantiate()
		fire.position = player.position
		add_child( fire )

# Intro screen label blink
func _on_start_label_timer_timeout():
	if $StartScreen/Start.visible :
		$StartScreen/Start.hide()
	else:
		$StartScreen/Start.show()

func lose_live() :
	
	# Paramos todo
	player.can_move = false
	
	if ( current_lives > 0 ) :
		current_lives = current_lives - 1
		update_lives( )
		$DyingTimer.start()
		
	if ( current_lives == 0 ) :
		$GameOverScreen.visible = true
		$DyingTimer.stop()

func update_lives() :
	for i in range( max_lives  ) :
		var live_counter = i + 1 
		if ( live_counter <= current_lives ) :
			get_node( "UI/vides_" + str( live_counter )  ).show()
		else:
			get_node( "UI/vides_" + str( live_counter ) ).hide()
	

func object_killed( _type ) :
	if ( _type == 'base' ) :
		current_game_speed = current_game_speed - 0.08
		
	if ( current_game_speed <= 0 ) :
		current_game_speed = 0.01
		
func object_shooted( _type ) :
	if ( _type == 'rocket' ) :
		current_game_speed = current_game_speed - 0.1
	if ( current_game_speed <= 0 ) :
		current_game_speed = 0.01

func _on_dying_timer_timeout() :
	# Reseteamos posicion nave
	var level_boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.11 }
	player.position =  Vector3( ( level_boundaries.left + level_boundaries.right ) / 2, 
								( level_boundaries.top - level_boundaries.bottom ) / 2 , 
								-2 )
	camera.position.z = -2	
	
	# Habilitamos movimiento
	player.can_move = true


func _on_fire_timer_timeout():
	can_fire = true


# Speed up if not max speed
func _on_second_timer_timeout():
	var minimum_acceleration = 0.1
	
	if ( current_game_speed < game_speed ) :
		var new_speed = current_game_speed * 0.10 
		if ( new_speed < 0.1 ) :
			new_speed = 0.1
		current_game_speed += new_speed
