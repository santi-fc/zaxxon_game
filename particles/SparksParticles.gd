extends GPUParticles3D

var animation_started = false

signal particles_ended

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Particle animation starts
	if ( not animation_started and emitting ) :
		animation_started = true
		
	# Particle animation ends
	if ( animation_started and not emitting ) :
		get_parent().get_parent().fire_ended.emit()
	
