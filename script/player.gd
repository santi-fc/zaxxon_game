extends CharacterBody3D

var movement_step_horizontal = 1
var movement_step_vertical =  1
var movement_rotation = 10
var boundaries = { 'left' : 0.65, 'right' : -0.7, 'top' : 0.6, 'bottom' : 0.09 }


func _physics_process( delta ):
	
	if Input.is_action_pressed( 'Pausa' ) :
		GLOBAL.level_moving = not GLOBAL.level_moving 
		
	if not GLOBAL.level_moving :
		return
	
	var moved = false
	if Input.is_action_pressed( 'move_right' ) and boundaries.right < position.x :
		position.x -= movement_step_horizontal * delta
		rotation.z = -movement_rotation * delta
		moved = true
	
	if Input.is_action_pressed( 'move_left' ) and boundaries.left > position.x :
		position.x += movement_step_horizontal * delta
		rotation.z = movement_rotation * delta
		moved = true

	if Input.is_action_pressed( 'move_up' ) and boundaries.top > position.y :
		position.y += movement_step_vertical * delta
		moved = true
		
	if Input.is_action_pressed( 'move_down' ) and boundaries.bottom < position.y :
		position.y -= movement_step_vertical * delta
		moved = true
		
	if Input.is_action_pressed( 'fire' ) :
		get_parent().make_fire()
		
	
	if not moved :
		rotation.z = 0
		
	move_and_slide()

	for index in range( get_slide_collision_count() ) :
		
		var collision = get_slide_collision( index )
		if collision.get_collider().is_in_group('level_end') :
			get_parent().level_finished()
			
		player_crash()
	
func player_crash():
	var explosion = get_node( 'boom' )
	explosion.show()
	explosion.get_node('BoomParticle3D').one_shot = true
	explosion.get_node('BoomParticle3D').start()

	get_node('Pivot').hide()
	get_parent().player_crashed()




func reset():
	get_node('Pivot').show()
	visible = true
