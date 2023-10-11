extends Node

var player_scene 		= preload("res://scenes/player.tscn")
var fire_scene   		= preload("res://scenes/fire.tscn")
var fire_enemy_scene    = preload("res://scenes/fire_red.tscn")
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	if $UI.visible: 
		$UI/ProgressBar.value = current_game_speed / game_speed * 100
		$UI/FPS.text = "FPS: " + str( Engine.get_frames_per_second() )

func _ready():
	$StartScreen.visible = false
	$UI.visible = false
	$GameOverScreen.visible = false
	$LevelComplete.visible = false
	# DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	
	await get_tree().create_timer(1.0).timeout
	if ( ! $UI.visible ) :
		$SplashScreenGodot.visible = true
		$SplashScreenGodot.start()
		$SplashScreenGodot.splash_screen_ended.connect( _on_splash_screen_ended )
	

func _on_splash_screen_ended():
	$SplashScreenGodot.visible = false
	# Process can arrive here and be already playing... we checked it
	if not $UI.visible :
		show_start_screen()

func _physics_process( delta ) :
	# Move player and camera
	current_time += delta
	#if ( current_time > 1.5 ) :
	#	return
	if player and player.can_move :
		camera.position.z += current_game_speed * delta
		if ( current_time > 0.7 ) :
			player.position.z += current_game_speed * delta
	
	if Input.is_action_pressed( 'Pausa' ) :
		player.can_move = not player.can_move
		
func _unhandled_input( event ):
	
	if not ( event is InputEventKey and event.pressed ) :
		return
		
	# Si estamos en la parte de splash pasamos a la ventana de start
	if $SplashScreenGodot.visible :
		_on_splash_screen_ended()
		return
	
	# En la pantalla de start
	if $StartScreen.visible :
		# Game begins
		start_game()
		return
		
	# En la pantalla de Game Over
	var keep_on_pressed = event.is_action_pressed("ui_accept") or event.is_action_pressed( 'fire' )
	if $GameOverScreen.visible and keep_on_pressed :
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
		player.reset()
			
	

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
	
	
	player.initialize({ 'level_boundaries' : level_boundaries })
	add_child( player )
	
func load_level( _which_one ) :
	if current_level_num != _which_one :
		level = load("res://niveles/nivel_1.tscn")

	var level_instance = level.instantiate()
	current_level = level_instance
	current_level_num = _which_one
	add_child( level_instance )

func show_start_screen() :
	if not $StartScreen.visible :
		$SplashScreenGodot.visible = false
		$GameOverScreen.visible = false
		$UI.visible = false 
		$StartScreen.visible = true
		blink_start_text()

func blink_start_text() :
	if $StartScreen.visible :
		$StartScreen/Start.visible = ! $StartScreen/Start.visible
		await get_tree().create_timer( 0.6 ).timeout 
		blink_start_text()


func make_fire() :
	if can_fire :
		can_fire = false
		$FireTimer.start()

		var fire = fire_scene.instantiate()
		fire.position = player.position
		add_child( fire )

func make_enemy_fire( _object_name ) :
	var firing_object = current_level.get_node( str( _object_name ) )
	var firing = fire_enemy_scene.instantiate()
	firing.is_enemy_fire = true
	firing.global_position = firing_object.global_position
	current_level.add_child( firing )

func lose_live() :
	# Paramos todo
	player.can_move = false

	if current_lives > 0 :
		current_lives = current_lives - 1
		update_lives()
		$DyingTimer.start()

	if current_lives == 0 :
		$EndGameTimer.start()
		$DyingTimer.stop()


func update_lives():
	for i in range( max_lives  ):
		var live_counter = i + 1 
		if live_counter <= current_lives :
			get_node( "UI/vides_" + str( live_counter )  ).show()
		else:
			get_node( "UI/vides_" + str( live_counter ) ).hide()

func object_killed( _type ):
	if _type == 'base' :
		current_game_speed = current_game_speed - 0.20
		
	if current_game_speed <= 0 :
		current_game_speed = 0.01
		
func object_shooted( _type ):
	if _type == 'rocket' :
		current_game_speed = current_game_speed - 0.20
		
	if current_game_speed <= 0 :
		current_game_speed = 0.01

func _on_dying_timer_timeout():
	# Reseteamos posicion nave
	var level_boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.11 }
	player.position =  Vector3( 
		( level_boundaries.left + level_boundaries.right ) / 2, 
		( level_boundaries.top - level_boundaries.bottom ) / 2 , 
		-2 
		)
	camera.position.z = -2	

	# Reseteamos nivel :)
	load_level( current_level_num )
	player.get_node('Pivot').show()
	
	player.get_node('boom/BoomParticle3D').show()
	player.get_node('boom/BoomParticle3D').waiting = false
	player.get_node('boom').show()
	
	# Habilitamos movimiento
	player.can_move = true

func level_finished():
	$LevelComplete.visible = true
	await get_tree().create_timer( 5.0 ).timeout
	

func _on_end_game_timer_timeout():
	$GameOverScreen.visible = true

func _on_fire_timer_timeout():
	can_fire = true

# Speed up if not max speed
func _on_second_timer_timeout():

	if current_game_speed < game_speed:
		var new_speed = current_game_speed * 0.10 
		if new_speed < 0.1 :
			new_speed = 0.1
		current_game_speed += new_speed
		if current_game_speed > game_speed :
			current_game_speed = game_speed
