extends Node3D

var start_hide = false
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var particle_node = get_node( 'GPUParticles3D' )
	if ( start_hide ) :
		timer = timer + ( 1 * delta )
		if ( timer > 3 ) :
			particle_node.emitting = false
		start_hide = false
	
	if not particle_node.is_emitting() :
		if ( timer > 3 + particle_node.lifetime ) :
			self.queue_free()


func hide_slowly() :
	start_hide = true
	
