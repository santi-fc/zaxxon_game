extends RayCast3D

@onready var beam_mesh = $BeamMesh
@onready var beam_collider = $BeamMesh/StaticBody3D/CollisionShape3D

var height_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var cast_point
	force_raycast_update()

	if not height_done and is_colliding() :
		height_done = true
		# Do LaserMesh be long enough to collide box
		cast_point = to_local(get_collision_point())
		
		beam_mesh.mesh.height = cast_point.y
		beam_mesh.position.y = cast_point.y / 2
		if ( cast_point.y < 0 ) :
			beam_collider.shape.height = cast_point.y * -1 
		if ( cast_point.y > 0 ) :
			beam_collider.shape.height = cast_point.y
		
		beam_collider.position.y = - cast_point.y / 2
