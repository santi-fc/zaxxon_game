class_name ScenaryObject extends StaticBody3D

@export var health = 3  # default health

var fog_particles   = load("res://particles/fog.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_shoot() :
	health = health - 1
	var fog = fog_particles.instantiate()
	fog.position = get_node( 'CollisionShape3D' ).position
	add_child( fog )
		
	if ( health == 0 ) :
		hide()
		#remove_child(self)
		queue_free()
