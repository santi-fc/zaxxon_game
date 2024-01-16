extends CharacterBody3D

var movement_step_horizontal = 0.4
var movement_step_vertical =  0.4
var movement_rotation = 10
var boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.09 }

var deceleration_factor = 0.8
var speed_x = 0
var speed_y = 0

func _physics_process( delta ):
	
	if Input.is_action_pressed( 'Pausa' ) :
		GLOBAL.level_moving = not GLOBAL.level_moving 
		
	if not GLOBAL.level_moving :
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
	
	if position.x < boundaries.right  :
		position.x = boundaries.right
	if position.x > boundaries.left  :
		position.x = boundaries.left
	if boundaries.top < position.y :
		position.y = boundaries.top
	if boundaries.bottom > position.y :
		position.y = boundaries.bottom
	
	if not moved :
		rotation.z = 0
	
		
	move_and_slide()

	for index in range( get_slide_collision_count() ) :
		
		var collision = get_slide_collision( index )
		if collision.get_collider().is_in_group('level_end') :
			get_parent().level_finished()
		player_crash()


func player_crash():
	$FX_Explode.play()
	var explosion = get_node( 'boom' )
	explosion.show()
	explosion.get_node('BoomParticle3D').one_shot = true
	explosion.get_node('BoomParticle3D').start()
	

	get_node('Pivot').hide()
	get_parent().player_crashed()




func reset():
	get_node('Pivot').show()
	visible = true
