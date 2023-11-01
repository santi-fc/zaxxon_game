extends Node3D

var fire_scene   		= preload("res://scenes/fire.tscn")
var fire_enemy_scene    = preload("res://scenes/fire_red.tscn")

var player
var camera
var current_level
var current_level_num = 1
var current_time : float

var player_initial_position : Vector3
var camera_initial_position : Vector3

func _ready():
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


func start_game():
	$UI.show()
	camera = get_node("CameraPivot");
	camera.position.z = -2
	GLOBAL.level_moving = true
	player_initial_position = GLOBAL.player.position
	camera_initial_position = camera.position


func make_fire() :
	if GLOBAL.player_can_fire :
		GLOBAL.player_can_fire = false
		$FireTimer.start()

		var fire = fire_scene.instantiate()
		fire.position = GLOBAL.player.position
		add_child( fire )


func _on_fire_timer_timeout():
	GLOBAL.player_can_fire = true


func make_enemy_fire( firing_object ) :
	var firing = fire_enemy_scene.instantiate()
	firing.is_enemy_fire = true
	firing.position = firing_object.global_position
	firing.position.y += 0.1
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


func level_finished():
	$LevelComplete.visible = true
	await get_tree().create_timer( 5.0 ).timeout
	

func _on_end_game_timer_timeout():
	GLOBAL.goto_scene( GLOBAL.SCENE_GAME_OVER )


func show_fps():
	$UI/FPS.text = "FPS: " + str( Engine.get_frames_per_second() )
