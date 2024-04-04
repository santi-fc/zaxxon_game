extends CharacterBody3D

var movement_step_horizontal = 0.6
var movement_step_vertical =  0.4
var movement_rotation = 10

var deceleration_factor = 0.8
var speed_x = 0
var speed_y = 0

func _physics_process( delta ) -> void :
	
	# If player must be moved to center
	if GLOBAL.player_to_center :
		position = lerp( position, 
							Vector3( 
								( GLOBAL.level_boundaries.right + GLOBAL.level_boundaries.left ) / 2, 
								( GLOBAL.level_boundaries.top + GLOBAL.level_boundaries.bottom ) / 2, 
								position.z ), 
								delta * GLOBAL.player_to_center_speed )
			
	if Input.is_action_pressed( 'Pausa' ) :
		GLOBAL.level_moving = not GLOBAL.level_moving 
		
	if not GLOBAL.level_moving or GLOBAL.player_stopped :
		return
	
	var moved = false
	if Input.is_action_pressed( 'move_right' )  :
		position.x -= movement_step_horizontal * delta
		rotation.z = -movement_rotation * delta
		speed_x = -movement_step_horizontal
		moved = true
	elif Input.is_action_pressed( 'move_left' ) :
		position.x += movement_step_horizontal * delta
		rotation.z = movement_rotation * delta
		speed_x = movement_step_horizontal
		moved = true
	
	if Input.is_action_pressed( 'move_up' ) :
		position.y += movement_step_vertical * delta
		speed_y = movement_step_vertical
		moved = true
	elif Input.is_action_pressed( 'move_down' ) :
		position.y -= movement_step_vertical * delta
		speed_y = -movement_step_vertical
		moved = true
	
	if Input.is_action_pressed( 'fire' ) :
		get_parent().make_fire()
	
	# Deceleration	
	if speed_x >= 0.1 :
		speed_x = speed_x * deceleration_factor
		position.x += speed_x * delta
	if speed_y >= 0.1 :
		speed_y = speed_y * deceleration_factor
		position.y += speed_y * delta
	
	if position.x < GLOBAL.level_boundaries.right  :
		position.x = GLOBAL.level_boundaries.right
	if position.x > GLOBAL.level_boundaries.left  :
		position.x = GLOBAL.level_boundaries.left
	if GLOBAL.level_boundaries.top < position.y :
		position.y = GLOBAL.level_boundaries.top
	if GLOBAL.level_boundaries.bottom > position.y :
		position.y = GLOBAL.level_boundaries.bottom
	
	if not moved :
		rotation.z = 0
		
	move_and_slide()

	for index in range( get_slide_collision_count() ) :
		player_crash()


func player_crash() -> void :
	$FX_Explode.play()
	var explosion = get_node( 'boom' )
	explosion.show()
	explosion.get_node('BoomParticle3D').one_shot = true
	explosion.get_node('BoomParticle3D').start()

	get_node('Pivot').hide()
	get_parent().player_crashed()


func reset() -> void :
	get_node('Pivot').show()
	visible = true
