extends Node3D

var start_position_z = 0;
var max_distance     = 4
var speed            = 3

signal fire_ended;

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position_z = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process( delta ) :
	if ( start_position_z == 0 ) :
		start_position_z = position.z
	
	position.z += speed  * delta
	if ( position.z - start_position_z >= max_distance ) :
		hide()
		#queue_free()

func _on_body_entered( body ):
	
	get_node('MeshInstance3D').queue_free()
	get_node('CollisionShape3D').queue_free()
		
	var particle = get_node('sparks/SparksParticles')
	if body.is_in_group( 'enemigo' ) :
		body.get_shoot()
		particle.process_material.color_ramp.gradient.colors[ 0 ]  = Color("#ad8c52", 1)
		particle.process_material.color_ramp.gradient.colors[ 1 ]  = Color("#ad8c52", 0)
	
	if body is WallObject :
		particle.process_material.color_ramp.gradient.colors[ 0 ]  = Color( "blue", 1)
		particle.process_material.color_ramp.gradient.colors[ 1 ]  = Color( "blue", 0)
	
	particle.emitting = true


func _on_fire_ended():
	queue_free()
