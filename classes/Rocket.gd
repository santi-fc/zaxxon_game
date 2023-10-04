class_name Rocket extends StaticBody3D

@export var health = 4

var fog_particles   = load("res://particles/fog.tscn")
var rocket_speed_up = 0.006

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta ) :
	pass


func _physics_process( delta ) :
	# Calculamos distancia hasta jugador en eje Z
	var player = get_parent().get_parent().player
	
	if ( player ) :
		var player_position_z = player.global_transform.origin.z
		var rocket_position_z = global_transform.origin.z
		var distance = rocket_position_z - player_position_z
		if ( distance <= 4 ) :
			$Rocket.position.y = $Rocket.position.y + rocket_speed_up
			
func get_shoot() :
	health = health - 1
	var fog = fog_particles.instantiate()
	fog.position = get_node( 'Rocket' ).position
	add_child( fog )
	rocket_speed_up -= 0.0005
	get_node("/root/Main").object_shooted('rocket')
		
	if ( health == 0 ) :
		get_node("/root/Main").object_killed('rocket')
		hide()
		#remove_child(self)
		queue_free()
