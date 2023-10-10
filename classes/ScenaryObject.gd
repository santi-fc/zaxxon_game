class_name ScenaryObject extends StaticBody3D

@export var health = 3  # default health
@export var can_fire = false

var has_fog = false
var fog_particles      = preload("res://particles/fog.tscn")
var boom_particle 	   = preload("res://particles/boom.tscn")
var base_rota_scene    = preload("res://scenes/base_rota.tscn")
var torreta_rota_scene = preload("res://scenes/torreta_rota.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func get_shoot() :
	health = health - 1
	if ( ! has_fog ) :
		has_fog = fog_particles.instantiate()
		has_fog.position = get_node( 'CollisionShape3D' ).position
		has_fog.name = 'fog';
		add_child( has_fog )
		
	if ( health <= 0 ) :
		var object_name = get_object_type()
		get_node("/root/Main").object_killed( object_name )
		
		# Quitamos collider y mesh 
		for _i in self.get_children () :
			if ( ( _i.name != 'fog' ) && ( _i.name != 'broken' ) ): 
				_i.queue_free()
		
		# Añadimos explosion
		var boom = boom_particle.instantiate()
		var amount_gap = [50,200]
		boom.position = has_fog.position
		boom.get_node('BoomParticle3D').amount = amount_gap[ randi() % amount_gap.size() ]
		boom.get_node('BoomParticle3D').one_shot = true
		add_child(boom)
		
		get_node( 'fog' ).hide_slowly()
	


		
		
		# Añadimos item roto
		#if ( object_name == 'base' ): 
			#var base_rota = base_rota_scene.instantiate()
			#base_rota.position = has_fog.position - Vector3(0.008,0.04,0.03)
			#add_child( base_rota )
		
		if ( object_name == 'torreta' ) :
			var torreta_rota = torreta_rota_scene.instantiate()
			torreta_rota.position = has_fog.position - Vector3(0,0.1,0)
			add_child( torreta_rota )
			
func get_object_type() :
	if ( is_in_group( 'base' )) : 
		return 'base'
	if ( is_in_group( 'satelite' )) :
		return 'satelite'
	if ( is_in_group( 'torreta' )) :
		return 'torreta'
