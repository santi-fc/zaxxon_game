extends Node3D

var fire_scene   		= preload("res://scenes/fire.tscn")
var fire_enemy_scene    = preload("res://scenes/fire_red.tscn")

var ship_scene     = "res://scenes/enemy.tscn"

var player
var camera
var current_level
var current_level_num = 1
var current_time : float

var player_initial_position : Vector3
var camera_initial_position : Vector3

func _ready() : 
	$LevelComplete.hide()
	GLOBAL.player = get_node( 'Player' )
	GLOBAL.score_label = get_node( 'UI/Score' )
	start_game()
	show()


func _process( _delta ):
	if $UI.visible: 
		show_fps()


func _physics_process( delta ) :
	current_time += delta
	if GLOBAL.level_moving :
		camera.position.z += GLOBAL.game_speed * delta
		if current_time > 1.4 :
			GLOBAL.player.position.z += GLOBAL.game_speed * delta
	# Level complete animation

func start_game():
	update_UI()
	camera = get_node("CameraPivot");
	camera.position.z = -2
	GLOBAL.level_moving = true
	
	# Main player position is
	# x = 0 y = 0.223 z = -1.247
	# Camera z = -0.8  ( -0.4 from player)
	# Debug final of level
	#camera.position.z = 9.6
	#GLOBAL.player.position.z = 10
	
	player_initial_position = GLOBAL.player.position
	camera_initial_position = camera.position
	

func update_UI() :
	update_lives()
	GLOBAL.update_score()
	$UI.show()	

func make_fire() :
	if GLOBAL.player_can_fire :
		GLOBAL.player_can_fire = false
		$FireTimer.start()

		var fire = fire_scene.instantiate()
		fire.position = GLOBAL.player.position
		add_child( fire )


func _on_fire_timer_timeout():
	GLOBAL.player_can_fire = true


func make_enemy_fire( firing_object, position_object = null ) :
	var firing = fire_enemy_scene.instantiate()
	firing.is_enemy_fire = true
	firing.inmediate = true
	
	# if we have position_object, we get its position
	if ( position_object ) :
		firing.position = position_object.global_position
		firing.position.z -= 0.1
	else :
		firing.position = firing_object.global_position
		firing.position.y += 0.1
	
	firing.fire_ended.connect( firing_object.fire_ended )
	add_child( firing )


func player_crashed() :
	GLOBAL.level_moving = false

	if GLOBAL.current_lives > 0 :
		GLOBAL.current_lives = GLOBAL.current_lives - 1
		update_lives()
		$DyingTimer.start()

	if GLOBAL.current_lives == 0 :
		$EndGameTimer.start()
		$DyingTimer.stop()


func _on_dying_timer_timeout():
	GLOBAL.player.position =  player_initial_position
	camera.position = camera_initial_position
	# Habilitamos movimiento
	GLOBAL.level_moving = true
	GLOBAL.player.get_node('Pivot').show()
	# Reload Level
	GLOBAL.reload_level()


func update_lives():
	for i in range( GLOBAL.max_lives ):
		var live_counter = i + 1 
		if live_counter <= GLOBAL.current_lives :
			get_node( "UI/vides_" + str( live_counter )  ).show()
		else:
			get_node( "UI/vides_" + str( live_counter ) ).hide()


func level_finished() -> void :
	$LevelComplete.visible = true
	GLOBAL.player_stopped = true
	GLOBAL.player_to_center = true
	await get_tree().create_timer( 3.0 ).timeout
	start_space_level()
	

func _on_end_game_timer_timeout() -> void :
	GLOBAL.goto_scene( GLOBAL.SCENE_GAME_OVER )


func show_fps() -> void :
	$UI/FPS.text = "FPS: " + str( Engine.get_frames_per_second() )


func start_space_level() -> void :
	$LevelComplete/Label.visible = false
	$LevelComplete/Label.text = "Enemies aproaching!!"
	for n in 3 :
		await get_tree().create_timer( 0.5 ).timeout
		$LevelComplete/Label.visible = true
		await get_tree().create_timer( 0.5 ).timeout
		$LevelComplete/Label.visible = false
		
	await get_tree().create_timer( 0.5 ).timeout
	GLOBAL.set_camara_front()
	start_space_horde( 1 )
	
func start_space_horde( _level ) -> void :
	var ship_scene_loaded = ResourceLoader.load( ship_scene )
	
	var enemy_1
	
	for n in 10 : 
		# Instance the new scene
		enemy_1 = ship_scene_loaded.instantiate()
		enemy_1.scale = Vector3(0.08, 0.08, 0.08)
		enemy_1.position = Vector3( GLOBAL.player.position.x, GLOBAL.player.position.y, GLOBAL.player.position.z + 4 )
		enemy_1.can_fire = true
		enemy_1.behaviour = enemy_1.BEHAVIOUR_FIND_PLAYER
		# Add it to the active scene, as child of root
		get_tree().get_root().add_child( enemy_1 )
		await get_tree().create_timer( 3.0 ).timeout
