class_name Enemy 
extends Node3D

const BEHAVIOUR_NONE = 'static'
const BEHAVIOUR_TAKE_OFF = 'take_off'

var boom_particle = preload("res://particles/boom.tscn")
var enemy_dead = false
var taked_off = false

@export var health = 3 
@export var behaviour = Enemy.BEHAVIOUR_NONE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	var player = GLOBAL.player
	if player :
		var player_position_z = player.global_transform.origin.z
		var my_position_z = global_transform.origin.z
		var distance = my_position_z - player_position_z
		if distance <= 3 and get_node_or_null( 'AnimationPlayer' ) != null and not taked_off:
			taked_off = true
			$AnimationPlayer.play('take_off')

func get_shoot():
	health = health - 1
	
	# Looses health
	if health <= 0 and not enemy_dead:
		enemy_dead = true
		GLOBAL.object_killed( 'enemy_1' )
		
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


func _on_animation_player_animation_finished(anim_name):
	queue_free()
