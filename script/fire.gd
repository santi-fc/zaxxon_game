extends Node3D

var current_distance = 0;
var max_distance = 4
var speed = 3 # 3
var speed_enemy = 1 # 1
var is_enemy_fire = false
var inmediate = false
var collided = false

var real_fired = false
var timer_started = false
var inital_scale

signal fire_ended;


func _physics_process( delta ) :
	if is_enemy_fire :
		physics_process_enemy( delta )
	else :
		position.z += speed * delta
		current_distance += speed * delta
	
	if current_distance >= max_distance :
		fire_ended.emit()
		hide()
		queue_free()


func physics_process_enemy( delta ) :
	
	if ( inmediate ) :
		real_fired = true
		inital_scale = scale
		inmediate = false

	# Fire will appear one sec and then be real fired
	if not real_fired and not timer_started :
		inital_scale = scale
		position.z -= 0.1
		position.y = position.y + 0.05
		timer_started = true
		$EnemyFiredTimer.start()

	# Fire waiting !!
	if not real_fired and timer_started :
		scale = scale * 1.01

	# Fire moving !!
	if real_fired : 
		scale = inital_scale
		position.z -= speed_enemy * delta
		current_distance += speed_enemy * delta


func _on_body_entered( body ):
	if not collided :
		collided = true
		get_node('MeshInstance3D').queue_free()
		get_node('CollisionShape3D').queue_free()
		var particle = get_node('sparks/SparksParticles')
		if not is_enemy_fire and body.is_in_group( 'enemigo' ) :
			body.get_shoot()
			particle.process_material.color_ramp.gradient.colors[ 0 ] = Color("#ad8c52", 1)
			particle.process_material.color_ramp.gradient.colors[ 1 ] = Color("#ad8c52", 0)

		if is_enemy_fire and body.is_in_group( 'player' ) :
			GLOBAL.player.player_crash()
		
		if body is WallObject :
			particle.process_material.color_ramp.gradient.colors[ 0 ] = Color( "blue", 1)
			particle.process_material.color_ramp.gradient.colors[ 1 ] = Color( "blue", 0)

		particle.emitting = true
		particle.particles_ended.connect( _on_fire_ended )


func _on_fire_ended():
	hide()
	queue_free()


func _on_enemy_fired_timer_timeout():
	current_distance = 0
	real_fired = true
