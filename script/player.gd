extends CharacterBody3D

var movement_step_horizontal = 1
var movement_step_vertical   =  1
var movement_rotation        = 10
var can_move : bool = true

var boundaries = { 'left' : 0, 'right' : 0, 'top' : 0, 'bottom' : 0 }

func _physics_process( delta ):
	
	var moved = false;
	if ( ! can_move ) :
		return
	
	
	if Input.is_action_pressed( 'move_right' ) && boundaries.right < position.x :
		position.x -= movement_step_horizontal * delta
		rotation.z = -movement_rotation * delta
		moved = true
	
	if Input.is_action_pressed( 'move_left' ) && boundaries.left > position.x :
		position.x += movement_step_horizontal * delta
		rotation.z = movement_rotation * delta
		moved = true

	if Input.is_action_pressed( 'move_up' ) && boundaries.top > position.y :
		position.y += movement_step_vertical * delta
		moved = true
		
	if Input.is_action_pressed( 'move_down' ) && boundaries.bottom < position.y :
		position.y -= movement_step_vertical * delta
		moved = true
		
	if Input.is_action_pressed( 'fire' ) :
		get_parent().make_fire()
	
	if not moved :
		rotation.z = 0
	
	move_and_slide()
		
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		print( collision);
		if ( collision.get_collider().is_in_group('nivel')) :
			var explosion = get_node('boom')
			explosion.show()
			explosion.get_node('BoomParticle3D').one_shot = true
			explosion.get_node('BoomParticle3D').waiting = false
			explosion.get_node('BoomParticle3D').emitting = true
			
			get_node('Pivot').hide()
			get_parent().lose_live()
	
	

func initialize( params ) :
	if ( params.level_boundaries ) :
		boundaries = params.level_boundaries
