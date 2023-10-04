extends GPUParticles3D

var waiting = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) :
	if not is_emitting() and not waiting:
		# If is a player explosion, we hide, other exploxion remove
		var parent = get_parent().get_parent()
		if ( parent and parent.name == "Player") :
			waiting = true
			#hide()
		else :
			queue_free()
			
