class_name Rocket extends StaticBody3D

@export var health = 4

var fog_particles : PackedScene = preload("res://particles/fog.tscn")
var boom_particle : PackedScene = preload("res://particles/boom.tscn")
var object_fog
var rocket_speed_up = 0.005
var max_height : int = 2
var has_fog : bool = false
var is_dead : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _physics_process(_delta):
	if is_dead :
		return
	# Calculate distance from object to player
	var player = GLOBAL.player
	if player :
		var player_position_z = player.global_transform.origin.z
		var rocket_position_z = global_transform.origin.z
		var distance = rocket_position_z - player_position_z
		if distance <= 4 :
			$Rocket.position.y = $Rocket.position.y + rocket_speed_up
			if $Rocket.position.y >= max_height :
				queue_free()


func get_shoot() :
	health = health - 1
	# Add fog first time shooted
	if not has_fog :
		object_fog = fog_particles.instantiate()
		object_fog.name = 'fog';
		object_fog.position = get_node( 'Rocket' ).position
		add_child( object_fog )
		has_fog  = true

	if health <= 0 :
		is_dead = true
		GLOBAL.object_killed( 'rocket' )

		# Remove collider and mesh 
		for _i in self.get_children () :
			if  _i.name != 'fog' and _i.name != 'Crater' : 
				_i.queue_free()

		# Add explosion
		var boom = boom_particle.instantiate()
		var amount_gap = [ 50,200 ]
		boom.position = object_fog.position
		boom.get_node( 'BoomParticle3D' ).amount = amount_gap[ randi() % amount_gap.size() ]
		boom.get_node( 'BoomParticle3D' ).one_shot = true
		add_child( boom )

		get_node( 'fog' ).hide_slowly()
