class_name Enemy 
extends Node3D

const BEHAVIOUR_NONE = 'static'
const BEHAVIOUR_TAKE_OFF = 'take_off'
const BEHAVIOUR_FIND_PLAYER = 'find_player'

var boom_particle = preload("res://particles/boom.tscn")
var enemy_dead = false
var taked_off = false

var initial_position : Vector2
var moving_time : float = 0.0
var restart_movement : float = 0.0

@export var health = 3 
@export var behaviour = Enemy.BEHAVIOUR_NONE
@export var can_fire = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if can_fire :
		await get_tree().create_timer( 2 ).timeout 
		check_if_shoot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process( _delta ) -> void :
	var player = GLOBAL.player
	if self.behaviour == Enemy.BEHAVIOUR_TAKE_OFF :
		if player :
			var player_position_z = player.global_transform.origin.z
			var my_position_z     = global_transform.origin.z
			var distance          = my_position_z - player_position_z
			if distance <= 3 and get_node_or_null( 'AnimationPlayer' ) != null and not taked_off:
				taked_off = true
				$AnimationPlayer.play('take_off')
	if self.behaviour == Enemy.BEHAVIOUR_FIND_PLAYER :
		if not player :
			return
		# if distance <= 3, maintain distance 
		var player_position_z = player.global_transform.origin.z
		var my_position_z     = global_transform.origin.z
		var distance          = my_position_z - player_position_z
		var radious = 1
		var speed = 2 
		if  moving_time == 0 :
			initial_position = Vector2( position.x, position.y )
		# Start spinning
		moving_time += _delta
		var new_position = Vector2( sin( moving_time * speed ) * radious * 0.21, cos( moving_time * speed ) *  radious * 0.21 )
		position.x = initial_position.x + new_position.x
		position.y = initial_position.y + new_position.y
			
		if distance <= 2 :
			position.z = position.z + ( GLOBAL.game_speed * _delta )
			if restart_movement == 0 :
				restart_movement = _delta
			restart_movement += _delta
			if restart_movement > 4 :
				position.z = position.z - ( GLOBAL.game_speed * _delta )



func get_shoot():
	health = health - 1
	
	# Looses health
	if health <= 0 and not enemy_dead:
		enemy_dead = true
		GLOBAL.object_killed( 'enemy' )
		
		# Añadimos explosion
		var boom = boom_particle.instantiate()
		var amount_gap = [ 50,200 ]
		boom.position = get_node('nave_enemiga').position
		boom.name = 'boom'
		boom.get_node( 'BoomParticle3D' ).amount = amount_gap[ randi() % amount_gap.size() ]
		boom.get_node( 'BoomParticle3D' ).start()
		boom.get_node('BoomParticle3D').connect( 'particle_ended', on_particle_ended )
		add_child( boom )
		
		# Quitamos collider y mesh 
		for _i in self.get_children () :
			if  _i.name != 'boom' : 
				_i.queue_free()


func on_particle_ended():
	get_node('boom').queue_free()


func _on_animation_player_animation_finished(_anim_name):
	queue_free()
	
func check_if_shoot() :
	if GLOBAL.level_moving and health > 0  :
		randomize()
		var random_number = randf() * 10
		if random_number > 3 :
			make_fire()
		else :
			await get_tree().create_timer( 1 ).timeout 
			check_if_shoot()

# Called back by fire scene when fire ends
func fire_ended():
	check_if_shoot()

func make_fire() :
	GLOBAL.current_scene.make_enemy_fire( self, get_node('nave_enemiga') )
