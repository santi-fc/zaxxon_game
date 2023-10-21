class_name ScenaryObject extends StaticBody3D

@export var health = 3  # default health
@export var can_fire = false

var has_fog = false
var object_fog
var fog_particles      = preload("res://particles/fog.tscn")
var boom_particle 	   = preload("res://particles/boom.tscn")
var base_rota_scene
var torreta_rota_scene
var object_name = '';

# Called when the node enters the scene tree for the first time.
func _ready():
	self.object_name = 'scenary_object_' + str( randf() * 999999939 )
	#  break mesh load by type
	var object_type = get_object_type()
	if ( object_type == 'torreta' ) :
		torreta_rota_scene = preload("res://scenes/torreta_rota.tscn")
	if ( object_type == 'base' ) :
		base_rota_scene = preload("res://scenes/base_rota.tscn")
	# if object can fire start to do it !!
	if can_fire :
		await get_tree().create_timer( 2 ).timeout 
		check_if_shoot()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func check_if_shoot() :
	pass
#	randomize()
#	var random_number = randf() * 10
#	if random_number > 0 :
#		get_node("/root/Main").make_enemy_fire( self.name )
#
#	await get_tree().create_timer( 2 ).timeout 
#	check_if_shoot()
	
func get_shoot() :
	health = health - 1
	if not has_fog :
		object_fog = fog_particles.instantiate()
		object_fog.position = get_node( 'CollisionShape3D' ).position
		object_fog.name = 'fog';
		add_child( object_fog )
		has_fog = true
		
	if health <= 0 :
		var _object_name = get_object_type()
		GLOBAL.object_killed( _object_name )
		
		# Quitamos collider y mesh 
		for _i in self.get_children () :
			if  _i.name != 'fog' and _i.name != 'broken' : 
				_i.queue_free()

		# Añadimos explosion
		var boom = boom_particle.instantiate()
		var amount_gap = [ 50,200 ]
		boom.position = object_fog.position
		boom.get_node( 'BoomParticle3D' ).amount = amount_gap[ randi() % amount_gap.size() ]
		boom.get_node( 'BoomParticle3D' ).one_shot = true
		add_child( boom )

		get_node( 'fog' ).hide_slowly()
		
		# We add "broken" mesh
		match _object_name :
			'base' :
				var base_rota = base_rota_scene.instantiate()
				base_rota.position = object_fog.position
				add_child( base_rota )
			'torreta' :
				var torreta_rota = torreta_rota_scene.instantiate()
				torreta_rota.position = object_fog.position
				add_child( torreta_rota )
			
func get_object_type() :
	if is_in_group( 'base' ): 
		return 'base'
	if is_in_group( 'satelite' ):
		return 'satelite'
	if is_in_group( 'torreta' ) :
		return 'torreta'
