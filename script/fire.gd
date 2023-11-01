extends Node3D

var start_position_z = 0;
var max_distance = 4
var speed = 3
var speed_enemy = 1
var is_enemy_fire    = false
var collided = false

signal fire_ended;


func _physics_process( delta ) :
	if start_position_z == 0 :
		start_position_z = position.z

	if is_enemy_fire :
		position.z -= speed_enemy * delta
		if position.z + start_position_z <= max_distance :
			hide()
			queue_free()
	else :
		position.z += speed  * delta
		if position.z - start_position_z >= max_distance :
			hide()
			queue_free()


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
	queue_free()
