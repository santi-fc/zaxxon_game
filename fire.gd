extends Node3D

var start_position_z = 0;
var max_distance     = 4
var speed            = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	print('ready')
	start_position_z = 0;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process( delta ) :
	if ( start_position_z == 0 ) :
		start_position_z = position.z
	
	position.z += delta * speed 
	if ( position.z - start_position_z >= max_distance ) :
		hide()
		queue_free()


func _on_body_entered( body ):
	hide()
	queue_free()
	
	if body.is_in_group( 'enemigo' ) :
		body.get_shoot()
		pass

